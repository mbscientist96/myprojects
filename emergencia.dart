import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyPage extends StatelessWidget {
  final String emergencyNumber = '192'; // Número de emergência

  // Função para fazer a ligação e enviar o alerta
  Future<void> _makeEmergencyCall(BuildContext context) async {
    final url = 'tel:$emergencyNumber';
    if (await canLaunch(url)) {
      await launch(url);

      // Envia alerta ao Firestore sobre a situação crítica
      await _sendAlert(context, 'critical', 'Idoso em estado crítico, ligou para a ambulância');
    } else {
      print('Não foi possível realizar a ligação.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível realizar a ligação.')),
      );
    }
  }

  // Função para enviar alertas ao Firestore
  Future<void> _sendAlert(BuildContext context, String alertType, String message) async {
    await FirebaseFirestore.instance.collection('alerts').add({
      'type': alertType,
      'timestamp': Timestamp.now(),
      'message': message,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Alerta enviado: $message')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergência', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {},
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
                Text('Emergência', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _makeEmergencyCall(context), // Chama a função de emergência
                  icon: Icon(Icons.phone, color: Colors.white),
                  label: Text('Ligar para Emergência', style: TextStyle(fontSize: 25)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _sendAlert(context, 'non-emergency', 'Idoso está doente, mas não é emergência'),
                  icon: Icon(Icons.warning, color: Colors.white),
                  label: Text('Estou doente', style: TextStyle(fontSize: 27)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.yellow[700],
                    padding: EdgeInsets.symmetric(horizontal: 59, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
