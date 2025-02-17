
import 'package:flutter/material.dart';
import 'dart:async';
import 'db_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assistência de Medicação',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: LookMedicationScreen(),
    );
  }
}

class LookMedicationScreen extends StatefulWidget {
  @override
  _LookMedicationScreenState createState() => _LookMedicationScreenState();
}

class _LookMedicationScreenState extends State<LookMedicationScreen> {
  List<Map<String, dynamic>> medicamentos = [];
  double _fontSize = 18.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  _loadMedications() async {
    final data = await DBHelper().getAllMedications();
    setState(() {
      medicamentos = List.from(data);
    });
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
                Icon(Icons.medical_services, size: screenWidth * 0.08, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Remédios',
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
        itemCount: medicamentos.length,
        itemBuilder: (context, index) {
          final medicamento = medicamentos[index];

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
                medicamento['name'],
                style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Hora: ${medicamento['time']}',
                style: TextStyle(fontSize: _fontSize - 2),
              ),
            ),
          );
        },
      ),
    );
  }
}
