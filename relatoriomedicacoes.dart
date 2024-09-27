import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationLogScreen extends StatelessWidget {
  // Função para apagar os registros do Firestore
  Future<void> _clearLogs() async {
    final collection = FirebaseFirestore.instance.collection('medication_actions');
    var snapshots = await collection.get();

    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
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
                colors: [Colors.teal, Color.fromARGB(255, 105, 146, 215)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 3.0),
            child: Text(
              'Relatório de Medicações',
              textAlign: TextAlign.center,
              style: TextStyle(
                // Tamanho da fonte ajustado
                fontSize: screenWidth * 0.05,  // Reduzido de 0.08 para 0.06
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'RobotoMono',
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
          centerTitle: true,
          elevation: 10.0,
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                bool shouldClear = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Limpar Relatório'),
                    content: Text('Você tem certeza de que deseja apagar todos os registros?'),
                    actions: [
                      TextButton(
                        child: Text('Cancelar'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: Text('Apagar'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  ),
                );

                if (shouldClear) {
                  await _clearLogs();
                }
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('medication_actions')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var logs = snapshot.data!.docs;

          if (logs.isEmpty) {
            return Center(
              child: Text(
                'Nenhum medicamento tomado ainda.',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w500,
                  color: Colors.teal.shade800,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              var log = logs[index];
              String medicationName = log['medication_name'];
              String timeTaken = log['time_taken'];

              return Card(
                margin: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: Icon(
                    Icons.check_circle_outline,
                    color: Colors.teal,
                    size: screenWidth * 0.08,
                  ),
                  title: Text(
                    medicationName,
                    style: TextStyle(
                        fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Tomado às: $timeTaken',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  trailing: Icon(
                    Icons.access_time_rounded,
                    color: Colors.teal.shade300,
                    size: screenWidth * 0.07,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.02,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
