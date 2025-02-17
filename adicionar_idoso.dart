import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdicionarIdosoScreen extends StatefulWidget {
  @override
  _AdicionarIdosoScreenState createState() => _AdicionarIdosoScreenState();
}

// Função para verificar se o e-mail já existe na coleção 'users'
Future<DocumentSnapshot?> verificarEmailExistente(String email) async {
  try {
    // Consulta o Firestore para buscar um documento na coleção 'users' com o e-mail fornecido
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users') // Coleção 'users' que contém os idosos cadastrados
        .where('email', isEqualTo: email) // Verifica se o e-mail é igual ao fornecido
        .limit(1) // Limita a busca a um único documento
        .get();

    // Retorna o primeiro documento encontrado, se houver algum
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    }
    return null; // Retorna null se o e-mail não for encontrado
  } catch (e) {
    print('Erro ao verificar o e-mail: $e'); // Tratamento de erro
    return null;
  }
}

class _AdicionarIdosoScreenState extends State<AdicionarIdosoScreen> {
  final _formKey = GlobalKey<FormState>(); // Chave global para o formulário
  final TextEditingController _emailController = TextEditingController(); // Controlador para o campo de e-mail

  // Função para verificar e adicionar idoso se existir no Firestore
  Future<void> _verificarEAdicionarIdoso() async {
    String email = _emailController.text.trim(); // Remove espaços em branco do e-mail

    // Valida o formulário antes de continuar
    if (_formKey.currentState!.validate()) {
      DocumentSnapshot? userData = await verificarEmailExistente(email);

      // Se o e-mail foi encontrado
      if (userData != null) {
        // Adiciona o idoso à coleção 'idosos'
        await FirebaseFirestore.instance.collection('idosos').add({
          'name': userData['name'], // Pega o nome do documento encontrado
          'email': userData['email'], // Pega o e-mail do documento
        });

        // Mostra uma mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Idoso adicionado com sucesso à lista!')),
        );

        // Limpa o campo de e-mail após a adição
        _emailController.clear();
      } else {
        // Mostra uma mensagem de erro se o e-mail não for encontrado
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('E-mail não cadastrado.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar moderno
      appBar: AppBar(
        title: Text('Adicione Idosos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27.0),) ,
        backgroundColor: Colors.teal.shade700, // Cor personalizada para o AppBar
        centerTitle: true, // Centraliza o título
        elevation: 4, // Sombra para o AppBar
      ),
      // Corpo da interface com Padding para espaçamento
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Conecta o formulário à chave global
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Campo de e-mail com design moderno
              TextFormField(
                controller: _emailController, // Controlador para pegar o valor
                decoration: InputDecoration(
                  labelText: 'E-mail do Idoso',
                  labelStyle: TextStyle(color: Colors.teal.shade700), // Cor da label
                  filled: true,
                  fillColor: Colors.teal.shade50, // Fundo do campo de texto
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Bordas arredondadas
                    borderSide: BorderSide(color: Colors.teal.shade700), // Cor da borda
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal.shade900, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.teal.shade700), // Ícone dentro do campo
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o e-mail do idoso.'; // Validação do campo
                  }
                  // Expressão regular para validar o formato do e-mail
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor, insira um e-mail válido.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30), // Espaçamento entre o campo e o botão

              // Botão de ação com estilo moderno
              ElevatedButton(
                onPressed: _verificarEAdicionarIdoso, // Função que será chamada ao apertar o botão
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40),
                  child: Text(
                    'Adicionar Idoso à Lista', 
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.teal.shade700, // Cor do texto
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0), // Botão com bordas arredondadas
                  ),
                  elevation: 5, // Sombra do botão
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
