
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(AssistenciaApp());
}

class AssistenciaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercícios',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        hintColor: Colors.orange,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 18.0, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            backgroundColor: Colors.orange, // Background color
            foregroundColor: Colors.white, // Text color
            textStyle: TextStyle(fontSize: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5.0,
          ),
        ),
      ),
      home: ExercicioListScreen(),
    );
  }
}

class ExercicioListScreen extends StatelessWidget {
  final List<Exercicio> exercicios = [
    Exercicio(
      nome: 'Alongamento de Braços',
      duracao: 5,
      tutorial: 'Estenda os braços para frente, para cima e para os lados, '
          'segurando cada posição por alguns segundos.',
    ),
    Exercicio(
      nome: 'Alongamento de Pescoço',
      duracao: 2,
      tutorial: 'Gire o pescoço lentamente para os lados, para cima e para baixo.',
    ),
    Exercicio(
      nome: 'Pé de Galo',
      duracao: 1,
      tutorial: 'Fique em um pé só, segurando em uma cadeira para apoio. '
          'Tente manter o equilíbrio por 1 minuto.',
    ),
    Exercicio(
      nome: 'Respiração Profunda',
      duracao: 1,
      tutorial: 'Inspire profundamente pelo nariz, segure por alguns segundos e expire '
          'lentamente pela boca. Repita várias vezes.',
    ),
    Exercicio(
      nome: 'Rotação de Ombros',
      duracao: 2,
      tutorial: 'Mova os ombros em círculos para a frente e para trás, ajudando a aliviar a tensão.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, const Color.fromARGB(255, 105, 146, 215)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Exercícios',
          style: TextStyle(
            fontSize: 30.0,
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
        centerTitle: true,
        elevation: 10.0,
      ),
      body: ListView.builder(
        itemCount: exercicios.length,
        itemBuilder: (context, index) {
          final exercicio = exercicios[index];
          return ExercicioTile(exercicio: exercicio);
        },
      ),
    );
  }
}

class Exercicio {
  final String nome;
  final int duracao; // Duração em minutos
  final String tutorial;

  Exercicio({
    required this.nome,
    required this.duracao,
    required this.tutorial,
  });
}

class ExercicioTile extends StatefulWidget {
  final Exercicio exercicio;

  ExercicioTile({required this.exercicio});

  @override
  _ExercicioTileState createState() => _ExercicioTileState();
}

class _ExercicioTileState extends State<ExercicioTile> {
  Timer? _timer;
  int _secondsRemaining = 0;
  bool _isRunning = false;

  void _startTimer() {
    setState(() {
      _secondsRemaining = widget.exercicio.duracao * 60;
      _isRunning = true;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _isRunning = false;
          timer.cancel();
        }
      });
    });
  }

  void _stopTimer() {
    setState(() {
      _isRunning = false;
      _timer?.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.exercicio.nome,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 10),
            Text(
              widget.exercicio.tutorial,
              style: TextStyle(fontSize: 18.0, color: Colors.black87),
              textAlign: TextAlign.justify, // Justifica o texto para melhor aparência
            ),
            SizedBox(height: 10),
            if (_isRunning)
              Text(
                'Tempo restante: ${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 18.0, color: Colors.redAccent),
              ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isRunning ? null : _startTimer,
                    child: Text('Iniciar ${widget.exercicio.duracao} min'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Ajuste no padding do botão
                      foregroundColor: Colors.white, // Text color
                      backgroundColor: Colors.orange, // Background color
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isRunning ? _stopTimer : null,
                    child: Text('Parar'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Ajuste no padding do botão
                      foregroundColor: Colors.white, // Text color
                      backgroundColor: Colors.red, // Background color
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
