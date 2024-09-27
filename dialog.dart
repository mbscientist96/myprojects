import 'package:flutter/material.dart';

class MedicationReminderScreen extends StatefulWidget {
  @override
  _MedicationReminderScreenState createState() => _MedicationReminderScreenState();
}

class _MedicationReminderScreenState extends State<MedicationReminderScreen> {
  void showCustomDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hora do Medicamento!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('É hora de tomar o seu medicamento.'),
              SizedBox(height: 20),
              Image.asset('assets/remedio.png', height: 80), // Exemplo de imagem
              SizedBox(height: 20),
              Text(
                'Medicamento: Nome do Medicamento',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Horário: 14:00',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Lógica para marcar como "Tomado"
              },
              child: Text('Tomar Agora'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela de Medicação'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: showCustomDialog,
          child: Text('Testar Notificação'),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: MedicationReminderScreen()));
