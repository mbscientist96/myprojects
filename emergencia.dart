import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyPage extends StatelessWidget {
  final String emergencyNumber = '192'; 

  // Função para realizar a ligação de emergência
  Future<void> _makeEmergencyCall() async {
    final url = 'tel:$emergencyNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Não foi possível realizar a ligação.');
    }
  }

  // Função para registrar um alerta no Firestore
  Future<void> _sendAlert(BuildContext context) async {
    await FirebaseFirestore.instance.collection('alerts').add({
      'type': 'non-emergency', // Tipo de alerta
      'timestamp': Timestamp.now(), // Momento do alerta
      'message': 'Alerta Amarelo, o idoso está doente', // Mensagem de alerta
    });

    // Navega para a tela de alerta
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergência', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              // Ação para o ícone de ajuda
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.redAccent, Colors.orangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber_rounded, size: 100, color: Colors.white),
                SizedBox(height: 20),
                Text(
                  'Emergência',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _makeEmergencyCall,
                  icon: Icon(Icons.phone, color: Colors.white),
                  label: Text('Ligar para Emergência', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, 
                    backgroundColor: Colors.red, 
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _sendAlert(context),
                  icon: Icon(Icons.warning, color: Colors.white),
                  label: Text('Registrar Alerta', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, 
                    backgroundColor: Colors.yellow[700], 
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
