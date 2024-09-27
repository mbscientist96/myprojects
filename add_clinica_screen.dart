
import 'package:flutter/material.dart';
import 'clinica.dart'; // Importando a classe Clinica

class AddClinicaScreen extends StatefulWidget {
  final Function(Clinica) onSave;

  AddClinicaScreen({required this.onSave});

  @override
  _AddClinicaScreenState createState() => _AddClinicaScreenState();
}

class _AddClinicaScreenState extends State<AddClinicaScreen> {
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _horarioController = TextEditingController();

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
      id: DateTime.now().millisecondsSinceEpoch, // Gera um ID único
      nome: nome,
      telefone: telefone,
      horario: horario,
    );

    widget.onSave(clinica);
    Navigator.of(context).pop(clinica); // Retorna a clínica para a página anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Clínica'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome da Clínica'),
            ),
            TextField(
              controller: _telefoneController,
              decoration: InputDecoration(labelText: 'Telefone'),
            ),
            TextField(
              controller: _horarioController,
              decoration: InputDecoration(labelText: 'Horário'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveClinica,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
