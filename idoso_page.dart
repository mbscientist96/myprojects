
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:tccassistencia/consulta.dart';
import 'package:tccassistencia/emergencia.dart';
import 'package:tccassistencia/exercicio_page.dart';
import 'medication_list_screen.dart';

void main() {
  // Inicializar Awesome Notifications
  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        channelKey: 'medication_channel',
        channelName: 'Canal de Remédios',
        channelDescription: 'Notificações para horários de remédios',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High, // Importância da notificação
        channelShowBadge: true, // Mostra o badge do canal
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
              fontSize: 28.0,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold),
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
          labelLarge: TextStyle(
              fontSize: 22.0,
              fontFamily: 'Roboto'),
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
        toolbarHeight: 0, // Remove a altura da AppBar para não ocupar espaço
      ),
      body: Stack(
        children: [
          // Camada de cor desbotada
          Positioned.fill(
            child: Container(
              color: Colors.teal.shade100, // Cor de fundo
            ),
          ),
          // Cabeçalho no topo sem bordas arredondadas
          Positioned(
            top: 0, // Ancorando o cabeçalho ao topo da tela
            left: 0,
            right: 0,
            child: Container(
              color: Colors.teal, // Cor de fundo do cabeçalho
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32), // Aumentando a altura do cabeçalho e as margens laterais
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // Centraliza o conteúdo
                children: [
                  Text('Assistência',
                      style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(width: 16),
                  // Espaçamento entre o texto e o ícone
                  Icon(Icons.elderly, size: 40, color: Colors.white),
                  // Aumentando o tamanho do ícone
                ],
              ),
            ),
          ),
          // Conteúdo principal deslocado para baixo
          Center(
            child: SingleChildScrollView( // Envolvendo o conteúdo com SingleChildScrollView
              padding: const EdgeInsets.only(top: 80.0, left: 16.0, right: 16.0), // Ajustando o padding superior para o conteúdo não ficar embaixo do cabeçalho
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  // Espaçamento entre o cabeçalho e o relógio

                  // Relógio estilizado sem fundo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time,
                          size: 64, color: Colors.teal.shade900),
                      // Aumentando o tamanho do ícone
                      SizedBox(width: 12), // Espaçamento entre o ícone e a hora
                      Text(
                        _currentTime,
                        style: TextStyle(
                          fontSize: 72.0, // Aumentando o tamanho do texto da hora
                          fontFamily: 'RobotoMono',
                          // Fonte personalizada para um estilo mais moderno
                          fontWeight: FontWeight.w700, // Tornando o texto mais espesso
                          color: Colors.teal.shade900,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.teal.shade300, // Sombra com tom mais claro
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  // Espaçamento entre os botões

                  // Botões alinhados um embaixo do outro
                  CustomButton(
                    label: 'Tomar Remédio',
                    icon: Icons.medication,
                    onPressed: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> MedicationListScreen()),
                      );

                    },
                  ),
                  SizedBox(height: 15),
                  // Espaçamento entre os botões

                  CustomButton(
                    label: 'Farmácias',
                    icon: Icons.local_pharmacy,
                    onPressed: () {
                      // Ação para o botão "Farmácias"
                    },
                  ),
                  SizedBox(height: 15),
                  // Espaçamento entre os botões

                  CustomButton(
                    label: 'Clinicas',
                    icon: Icons.local_hospital,
                    onPressed: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> ClinicasListPage()),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  // Espaçamento entre os botões

                  CustomButton(
                    label: 'Exercícios',
                    icon: Icons.fitness_center,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> ExercicioListScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  // Espaçamento entre os botões

                  CustomButton(
                    label: 'Emergência',
                    icon: Icons.warning,
                    onPressed: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> EmergencyPage()),
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
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
            horizontal: 40, vertical: 24), // Aumentando o padding dos botões
        foregroundColor: Colors.white, // Cor do texto e do ícone
        backgroundColor: color ?? Theme.of(context).primaryColor, // Cor de fundo do botão
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        textStyle: TextStyle(
          fontSize: 28.0, // Aumentando o tamanho do texto dos botões
          fontWeight: FontWeight.bold,
        ),
      ),
      icon: Icon(icon, size: 32), // Aumentando o tamanho do ícone
      label: Text(label),
      onPressed: onPressed,
    );
  }
}
