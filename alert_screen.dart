import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Para formatar a data e hora

class AlertScreen extends StatelessWidget {
  final Stream<QuerySnapshot> _alertStream = FirebaseFirestore.instance
      .collection('alerts')
      .snapshots();

  Future<void> _deleteAlert(String alertId) async {
    await FirebaseFirestore.instance.collection('alerts').doc(alertId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alertas de Saúde',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _alertStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            var alerts = snapshot.data!.docs;
            if (alerts.isEmpty) {
              return Center(
                child: Text(
                  'Nenhum alerta de saúde no momento.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }
            return ListView(
              children: alerts.map((alert) {
                // Obtenha o campo timestamp
                Timestamp timestamp = alert['timestamp'] ?? Timestamp.now();
                // Formate a data e hora
                String formattedDate = DateFormat('dd/MM/yyyy – HH:mm').format(timestamp.toDate());

                return Card(
                  color: alert['type'] == 'critical' ? Colors.red[100] : Colors.yellow[100],
                  child: ListTile(
                    title: Text(
                      alert['message'],
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Enviado em: $formattedDate',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Chama a função para deletar o alerta do Firestore
                        _deleteAlert(alert.id);
                      },
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
