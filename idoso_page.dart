import 'dart:async';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:tccassistencia/consulta.dart';
import 'package:tccassistencia/contact_list_screen.dart';
import 'package:tccassistencia/emergencia.dart';
import 'package:tccassistencia/exercicio_page.dart';
import 'medication_list_screen.dart';

void main() {
  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        channelKey: 'medication_channel',
        channelName: 'Canal de Remédios',
        channelDescription: 'Notificações para horários de remédios',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
    ],
  );

  runApp(AssistenciaApp());
}

class AssistenciaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assistência para Idosos e Deficientes',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyLarge: TextStyle(
              fontSize: 28.0, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
          titleLarge: TextStyle(
              fontSize: 36.0,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                    blurRadius: 10.0,
                    color: Colors.black26,
                    offset: Offset(2, 2)),
              ]),
          labelLarge: TextStyle(fontSize: 22.0, fontFamily: 'Roboto'),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.teal.shade100,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.teal,
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Assistência',
                      style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(width: 16),
                  Icon(Icons.elderly, size: 40, color: Colors.white),
                ],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 80.0, left: 16.0, right: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time,
                          size: 64, color: Colors.teal.shade900),
                      SizedBox(width: 12),
                      Text(
                        _currentTime,
                        style: TextStyle(
                          fontSize: 72.0,
                          fontFamily: 'RobotoMono',
                          fontWeight: FontWeight.w700,
                          color: Colors.teal.shade900,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.teal.shade300,
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    label: 'Tomar Remédio',
                    icon: Icons.medication,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MedicationListScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  CustomButton(
                    label: 'Contatos',
                    icon: Icons.perm_contact_cal,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContactListScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  CustomButton(
                    label: 'Clínicas',
                    icon: Icons.local_hospital,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClinicasListPage()),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  CustomButton(
                    label: 'Exercícios',
                    icon: Icons.fitness_center,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExercicioListScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  CustomButton(
                    label: 'Emergência',
                    icon: Icons.warning,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EmergencyPage()),
                      );
                    },
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  CustomButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Define largura total para botões grandes
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          foregroundColor: Colors.white,
          backgroundColor: color ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          textStyle: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
          elevation: 8, // Sombra para efeito visual
          shadowColor: Colors.black45,
        ),
        icon: Icon(icon, size: 32),
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }
}
