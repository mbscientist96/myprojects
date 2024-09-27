import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlertPage extends StatelessWidget {
  // Função para deletar todos os alertas de tipo "non-emergency"
  Future<void> _clearAlerts() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('alerts')
          .where('type', isEqualTo: 'non-emergency')
          .get();

      for (var doc in snapshot.docs) {
        await FirebaseFirestore.instance.collection('alerts').doc(doc.id).delete();
      }
      print("Alertas deletados com sucesso.");
    } catch (e) {
      print("Erro ao deletar alertas: $e");
    }
  }

  // Função para enviar um alerta ao Firestore
  Future<void> _sendAlertToFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('alerts').add({
        'type': 'non-emergency',
        'message': 'O idoso não está se sentindo bem, mas não é uma emergência.',
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Alerta enviado com sucesso.");
    } catch (e) {
      print("Erro ao enviar alerta: $e");
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alerta de Saúde', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amberAccent,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever, color: Colors.white),
            onPressed: () async {
              bool confirm = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Limpar Alertas'),
                    content: Text('Tem certeza de que deseja limpar todos os alertas?'),
                    actions: [
                      TextButton(
                        child: Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: Text('Confirmar'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );
              

              if (confirm == true) {
                await _clearAlerts();
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
  stream: FirebaseFirestore.instance
      .collection('alerts')
      .where('type', isEqualTo: 'non-emergency')
      .orderBy('timestamp', descending: true)
      .snapshots(),
  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    // Verifica o estado de conexão
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      print("Erro no Firestore: ${snapshot.error}"); // Log do erro
      return Center(child: Text('Erro ao carregar os dados.'));
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Center(
        child: Text(
          'Nenhum alerta registrado.',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      );
    }

    // Exibe os alertas
    var alerts = snapshot.data!.docs;
    print("Dados carregados: ${alerts.length} alertas encontrados"); // Log de sucesso

    return ListView.builder(
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        var alert = alerts[index];
        String message = alert['message'];

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          elevation: 5,
          color: Colors.yellow[100],
          child: ListTile(
            leading: Icon(Icons.warning_amber_rounded, color: Colors.yellow[700], size: 40),
            title: Text(
              'Alerta de Saúde',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.yellow[700]),
            ),
            subtitle: Text(
              message,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        );
      },
    );
  },
)

    );
  }
}
