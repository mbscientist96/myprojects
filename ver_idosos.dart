import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerIdososScreen extends StatelessWidget {
  // Chave global para o ScaffoldMessenger
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  // Função para deletar um idoso
  Future<void> _deletarIdoso(String id) async {
    try {
      await FirebaseFirestore.instance.collection('idosos').doc(id).delete();
      scaffoldKey.currentState?.showSnackBar(
        SnackBar(content: Text('Idoso excluído com sucesso.')),
      );
    } catch (e) {
      scaffoldKey.currentState?.showSnackBar(
        SnackBar(content: Text('Erro ao excluir idoso: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // Define a chave do ScaffoldMessenger
      appBar: AppBar(
        title: Text('Lista de Idosos', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 27),),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('idosos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar idosos.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Nenhum idoso cadastrado.'));
          }

          // Lista de idosos cadastrados
          final idosos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: idosos.length,
            itemBuilder: (context, index) {
              var idoso = idosos[index];

              return ListTile(
                title: Text(idoso['name']),
                subtitle: Text(idoso['email']),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Confirmar exclusão do idoso
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Excluir Idoso'),
                          content: Text('Tem certeza que deseja excluir este idoso?'),
                          actions: [
                            TextButton(
                              child: Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Excluir', style: TextStyle(color: Colors.red)),
                              onPressed: () async {
                                Navigator.of(context).pop(); // Fecha o diálogo
                                await _deletarIdoso(idoso.id); // Exclui o idoso do Firebase
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
