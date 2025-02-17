import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RelatorioExercicio extends StatelessWidget {
  Future<void> _clearExercicios(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar Exercícios'),
        content: Text('Tem certeza de que deseja limpar todos os exercícios registrados?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('relatorios')
            .get();

        for (var doc in snapshot.docs) {
          await FirebaseFirestore.instance.collection('relatorios').doc(doc.id).delete();
        }
        print("Todos os exercícios foram limpos com sucesso.");
      } catch (e) {
        print("Erro ao limpar exercícios: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório de Exercícios', style: TextStyle(color: Colors.white, fontSize: 21.0, fontWeight: FontWeight.bold)),
         
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () => _clearExercicios(context),
            tooltip: 'Limpar Exercícios',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('relatorios')
            .orderBy('data_hora', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os dados.', style: TextStyle(color: Colors.red)));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Nenhum exercício registrado.', style: TextStyle(fontSize: 18, color: Colors.grey)));
          }

          var relatorios = snapshot.data!.docs;

          return ListView.builder(
            itemCount: relatorios.length,
            itemBuilder: (context, index) {
              var relatorio = relatorios[index];
              String exercicio = relatorio['exercicio'];
              Timestamp dataHora = relatorio['data_hora'];
              String formattedDate = dataHora.toDate().toLocal().toString().split(' ')[0]; // Data
              String formattedTime = dataHora.toDate().toLocal().toString().split(' ')[1].split('.')[0]; // Hora

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.fitness_center, color: Colors.teal, size: 40),
                  title: Text('Exercício: $exercicio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text('Data: $formattedDate\nHora: $formattedTime', style: TextStyle(color: Colors.grey[600])),
                  trailing: Icon(Icons.chevron_right, color: Colors.teal),
                  contentPadding: EdgeInsets.all(16),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
