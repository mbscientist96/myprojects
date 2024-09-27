import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tccassistencia/add_medication_screen.dart';
import 'dart:async';
import 'db_helper.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() {
  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        channelKey: 'medication_channel',
        channelName: 'Canal de Medicação',
        channelDescription: 'Notificações para medicação',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assistência de Medicação',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MedicationListScreen(),
    );
  }
}

class MedicationListScreen extends StatefulWidget {
  @override
  _MedicationListScreenState createState() => _MedicationListScreenState();
}
void _registerMedicationTaken(int medicationId, String medicationName) async {
  final now = DateTime.now();
  final formattedTime = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';

  // Cria uma referência ao Firestore
  CollectionReference medicationsRef = FirebaseFirestore.instance.collection('medication_actions');

  // Envia os dados ao Firestore
  try {
    await medicationsRef.add({
      'medication_id': medicationId,
      'medication_name': medicationName,
      'time_taken': formattedTime,
      'timestamp': now,  // Adiciona o timestamp para ordenação futura
    });
    print('Ação registrada no Firebase com sucesso!');
  } catch (e) {
    print('Erro ao registrar a ação no Firebase: $e');
  }
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  List<Map<String, dynamic>> medicamentos = [];
  Map<int, bool> buttonStates = {};
  double _fontSize = 18.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadMedications();
    _checkMedicationTimes();
  }

  _loadMedications() async {
    final data = await DBHelper().getAllMedications();
    setState(() {
      medicamentos = List.from(data);
      _updateButtonStates();
    });
  }

  _checkMedicationTimes() {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (mounted) {
        setState(() {
          _updateButtonStates();
        });
      }
    });
  }

  _updateButtonStates() {
    final now = DateTime.now();
    final newButtonStates = <int, bool>{};

    for (var med in medicamentos) {
      final time = _parseTime(med['time']);
      final medicationTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      final isButtonEnabled = now.isAfter(medicationTime) && !(buttonStates[med['id']] ?? false);

      // O botão será habilitado somente no horário ou após o horário da medicação
      newButtonStates[med['id']] = isButtonEnabled;
    }

    setState(() {
      buttonStates = newButtonStates;
    });
  }

  _cancelAndRescheduleNotification(int id, String name, TimeOfDay time) async {
    await AwesomeNotifications().cancel(id);

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'medication_channel',
        title: 'Hora de tomar seu remédio',
        body: 'Está na hora de tomar o $name',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: time.hour,
        minute: time.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );
  }

  _deleteMedication(int id) async {
    try {
      await DBHelper().deleteMedication(id);

      setState(() {
        medicamentos.removeWhere((med) => med['id'] == id);
        buttonStates.remove(id);
      });

      await AwesomeNotifications().cancel(id);
    } catch (e) {
      print('Erro ao excluir medicamento: $e');
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  void _showFontSizeAdjustDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajustar Tamanho do Texto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Ajuste o tamanho do texto:'),
              Slider(
                value: _fontSize,
                min: 14.0,
                max: 30.0,
                divisions: 8,
                label: '${_fontSize.round()}',
                onChanged: (value) {
                  setState(() {
                    _fontSize = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isPortrait ? screenHeight * 0.1 : screenHeight * 0.15),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, const Color.fromARGB(255, 105, 146, 215)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.medical_services, size: screenWidth * 0.08, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Remédios',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RobotoMono',
                      letterSpacing: 1.5,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(3.0, 3.0),
                          blurRadius: 12.0,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.zoom_in, color: Colors.white),
                  iconSize: screenWidth * 0.08,
                  onPressed: _showFontSizeAdjustDialog,
                ),
              ],
            ),
          ),
          centerTitle: true,
          elevation: 10.0,
        ),
      ),
      body: ListView.builder(
        itemCount: medicamentos.length,
        itemBuilder: (context, index) {
          final medicamento = medicamentos[index];
          final time = _parseTime(medicamento['time']);
          final isButtonEnabled = buttonStates[medicamento['id']] ?? false;

          return Card(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.01),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.white,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
              title: Text(
                medicamento['name'],
                style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Hora: ${medicamento['time']}',
                style: TextStyle(fontSize: _fontSize - 2),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmar Exclusão'),
                            content: Text('Você tem certeza de que deseja excluir este medicamento?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancelar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Excluir'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _deleteMedication(medicamento['id']);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(width: 8),
                 ElevatedButton(
  onPressed: isButtonEnabled ? () {
    _cancelAndRescheduleNotification(
      medicamento['id'], 
      medicamento['name'], 
      time
    );
    
    // Registra a ação no Firebase
    _registerMedicationTaken(medicamento['id'], medicamento['name']);
    
    setState(() {
      buttonStates[medicamento['id']] = false;
    });
  } : null,
  child: Text(
    'Tomar Remédio',
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: _fontSize - 2),
  ),
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMedicationScreen()),
          );
          _loadMedications();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
