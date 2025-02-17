import 'package:flutter/material.dart';
import 'package:tccassistencia/add_clinica_screen.dart';
import 'package:tccassistencia/add_medication_screen.dart';
import 'package:tccassistencia/alert_screen.dart';
import 'package:tccassistencia/consulta.dart';
import 'package:tccassistencia/lookmedication.dart';

import 'package:tccassistencia/main.dart';
import 'package:tccassistencia/relatorioexercicio.dart'; // Tela de relatório de exercícios
import 'package:tccassistencia/relatoriomedicacoes.dart'; // Tela de relatório de remédios
import 'package:tccassistencia/adicionar_idoso.dart'; // Tela para adicionar idoso
import 'package:tccassistencia/ver_idosos.dart'; // Tela para ver idosos
import 'package:firebase_auth/firebase_auth.dart'; // Para logout


class ResponsiblePage extends StatelessWidget {
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Página do Responsável',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 5,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
            tooltip: 'Sair',
          ),
        ],
      ),
      backgroundColor: Colors.teal[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildElevatedButton(
                  context,
                  'Relatório de Remédios',
                  Colors.teal,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MedicationLogScreen()),
                    );
                  },
                ),
                 SizedBox(height: 16.0),
                _buildElevatedButton(
                  context,
                  'Adicionar Remédios',
                  Colors.green,
                  () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddMedicationScreen()),
                    );
                  },
                ),
                 SizedBox(height: 16.0),
                _buildElevatedButton(
                  context,
                  'Ver Remédios',
                  const Color.fromARGB(255, 47, 136, 50),
                  () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LookMedicationScreen()),
                    );
                  },
                ),
                SizedBox(height: 16.0),
                _buildElevatedButton(
                  context,
                  'Relatório de Exercícios',
                  Colors.teal,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RelatorioExercicio()),
                    );
                  },
                ),
                SizedBox(height: 16.0),
                _buildElevatedButton(
                  context,
                  'Emergência',
                  Colors.red,
                  () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AlertScreen()),
                    );
                  },
                ),
               
                SizedBox(height: 16.0),
                _buildElevatedButton(
                  context,
                  'Registrar Consulta',
                  Colors.orange,
                  () {
                   Navigator.push(
                  context,
               MaterialPageRoute(
                 builder: (context) => AddClinicaScreen(),
            ),
        );  
                    
                  },
                ),
                SizedBox(height: 16.0),
                _buildElevatedButton(
                  context,
                  'Consultas Agendadas',
                  Colors.purple,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ClinicasListPage()),
                    );
                  },
                ),
                SizedBox(height: 16.0),
                _buildElevatedButton(
                  context,
                  'Adicionar Idoso',
                  Colors.blue,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdicionarIdosoScreen()),
                    );
                  },
                ),
                SizedBox(height: 16.0),
                _buildElevatedButton(
                  context,
                  'Ver Idosos',
                  Colors.indigo,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VerIdososScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildElevatedButton(BuildContext context, String title, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
} 