
import 'package:flutter/material.dart';
import 'clinica.dart'; // Importando a classe Clinica
import 'add_clinica_screen.dart';

class ClinicasListPage extends StatefulWidget {
  @override
  _ClinicasListPageState createState() => _ClinicasListPageState();
}

class _ClinicasListPageState extends State<ClinicasListPage> {
  final List<Clinica> _clinicas = [];

  double _fontSize = 18.0;

  void _showFontSizeAdjustDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajustar Tamanho do Texto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Ajuste o tamanho do texto:'),
              Slider(
                value: _fontSize,
                min: 14.0,
                max: 30.0,
                divisions: 8,
                label: '${_fontSize.round()}',
                onChanged: (value) {
                  setState(() {
                    _fontSize = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddClinicaScreen() async {
    final newClinica = await Navigator.push<Clinica>(
      context,
      MaterialPageRoute(
        builder: (context) => AddClinicaScreen(
          onSave: (clinica) {
            // A nova clínica será retornada via Navigator.pop
          },
        ),
      ),
    );

    if (newClinica != null) {
      setState(() {
        _clinicas.add(newClinica);
      });
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
                colors: [Colors.teal, const Color.fromARGB(255, 105, 146, 215)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_hospital, size: screenWidth * 0.08, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Clínicas',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RobotoMono',
                      letterSpacing: 1.5,
                      color: Colors.white,
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
                IconButton(
                  icon: Icon(Icons.zoom_in, color: Colors.white),
                  iconSize: screenWidth * 0.08,
                  onPressed: _showFontSizeAdjustDialog,
                ),
              ],
            ),
          ),
          centerTitle: true,
          elevation: 10.0,
        ),
      ),
      body: ListView.builder(
        itemCount: _clinicas.length,
        itemBuilder: (context, index) {
          final clinica = _clinicas[index];

          return Card(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.01),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.white,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
              title: Text(
                clinica.nome,
                style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Telefone: ${clinica.telefone}\nHorário: ${clinica.horario}',
                style: TextStyle(fontSize: _fontSize - 2),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _clinicas.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: _navigateToAddClinicaScreen,
        child: Text('Adicionar Clínica'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5.0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
