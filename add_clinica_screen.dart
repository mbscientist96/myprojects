import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import necessário para o Firestore
import 'clinica.dart'; // Importando a classe Clinica

class AddClinicaScreen extends StatefulWidget {
  final Function(Clinica)? onSave; // onSave agora é opcional

  AddClinicaScreen({this.onSave});

  @override
  _AddClinicaScreenState createState() => _AddClinicaScreenState();
}

class _AddClinicaScreenState extends State<AddClinicaScreen> {
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _horarioController = TextEditingController();

  // Função para salvar a clínica no Firestore
  Future<void> _saveClinicaToFirestore(Clinica clinica) async {
    await FirebaseFirestore.instance.collection('clinicas').add({
      'nome': clinica.nome,
      'telefone': clinica.telefone,
      'horario': clinica.horario,
      'id': clinica.id,
    });
  }

  void _saveClinica() {
    final nome = _nomeController.text;
    final telefone = _telefoneController.text;
    final horario = _horarioController.text;

    if (nome.isEmpty || telefone.isEmpty || horario.isEmpty) {
      // Exibe uma mensagem de erro se os campos não estiverem preenchidos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Todos os campos devem ser preenchidos!')),
      );
      return;
    }

    final clinica = Clinica(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Gera um ID único
      nome: nome,
      telefone: telefone,
      horario: horario,
    );

    // Salva a clínica no Firestore
    _saveClinicaToFirestore(clinica);

    // Chama a função onSave, se não for nula
    if (widget.onSave != null) {
      widget.onSave!(clinica);
    }

    // Retorna à página anterior após salvar
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adicionar Clínica',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: _nomeController,
              label: 'Nome da Clínica',
              icon: Icons.local_hospital,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _telefoneController,
              label: 'Telefone',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _horarioController,
              label: 'Horário',
              icon: Icons.access_time,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveClinica,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Salvar',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para construir um campo de texto estilizado
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
