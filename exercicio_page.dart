import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Exercicio {
  final String nome;
  final int duracao; // Duração em segundos
  final String tutorial;

  Exercicio({
    required this.nome,
    required this.duracao,
    required this.tutorial,
  });
}

class ExercicioListScreen extends StatelessWidget {
  final List<Exercicio> exercicios = [
    Exercicio(
      nome: 'Alongamento de Braços',
      duracao: 5,
      tutorial: 'Estenda os braços para frente, para cima e para os lados, segurando cada posição por alguns segundos.',
    ),
    Exercicio(
      nome: 'Alongamento de Pescoço',
      duracao: 5,
      tutorial: 'Gire o pescoço lentamente para os lados, para cima e para baixo.',
    ),
    Exercicio(
      nome: 'Pé de Galo',
      duracao: 5,
      tutorial: 'Fique em um pé só, segurando em uma cadeira para apoio. Tente manter o equilíbrio por 5 segundos.',
    ),
    Exercicio(
      nome: 'Respiração Profunda',
      duracao: 5,
      tutorial: 'Inspire profundamente pelo nariz, segure por alguns segundos e expire lentamente pela boca. Repita várias vezes.',
    ),
    Exercicio(
      nome: 'Rotação de Ombros',
      duracao: 5,
      tutorial: 'Mova os ombros em círculos para a frente e para trás, ajudando a aliviar a tensão.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Exercícios Físicos',
          style: TextStyle(fontSize: 28, color: Colors.white),
           
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
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
      _secondsRemaining = widget.exercicio.duracao;
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
          _logExercicio();
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

  Future<void> _logExercicio() async {
    try {
      await FirebaseFirestore.instance.collection('relatorios').add({
        'exercicio': widget.exercicio.nome,
        'data_hora': FieldValue.serverTimestamp(),
      });
      print("Exercício registrado com sucesso.");
    } catch (e) {
      print("Erro ao registrar exercício: $e");
    }
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
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.exercicio.nome,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 10),
            Text(
              widget.exercicio.tutorial,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 10),
            if (_isRunning)
              Text(
                'Tempo restante: ${_secondsRemaining}s',
                style: TextStyle(fontSize: 20, color: Colors.redAccent),
              ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? null : _startTimer,
                  child: Text('Iniciar ${widget.exercicio.duracao} seg'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isRunning ? _stopTimer : null,
                  child: Text('Parar'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
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
