import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'db_helper.dart';

class AddMedicationScreen extends StatefulWidget {
  @override
  _AddMedicationScreenState createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final TextEditingController _nameController = TextEditingController();
  TimeOfDay? _selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveMedication() async {
    final String name = _nameController.text.trim();
    final TimeOfDay? time = _selectedTime;

    if (name.isEmpty || time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    // Salva no banco de dados
    final int id = await DBHelper().insertMedication({
      'name': name,
      'time': time.format(context),
    });

    // Agenda a notificação
    await _scheduleNotification(id, name, time);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Medicação adicionada com sucesso!')),
    );

    Navigator.of(context).pop();
  }

  Future<void> _scheduleNotification(int id, String name, TimeOfDay time) async {
    final DateTime now = DateTime.now();
    final DateTime scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Se o horário já passou no dia de hoje, agenda para o próximo dia
    if (scheduledDate.isBefore(now)) {
      scheduledDate.add(Duration(days: 1));
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'medication_channel',
        title: 'Hora de tomar seu remédio',
        body: 'Está na hora de tomar $name',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: time.hour,
        minute: time.minute,
        second: 0,
        millisecond: 0,
        repeats: true, // Notificação diária
        preciseAlarm: true, // Garante que a notificação seja precisa
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Medicação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome do Remédio'),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedTime != null
                        ? 'Horário: ${_selectedTime!.format(context)}'
                        : 'Selecione um horário',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: () => _selectTime(context),
                  child: Text('Escolher Horário'),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _saveMedication,
              child: Text('Salvar'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
