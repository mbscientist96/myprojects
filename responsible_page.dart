import 'package:flutter/material.dart';
import 'package:tccassistencia/alerta.dart';

import 'package:tccassistencia/relatoriomedicacoes.dart';

class ResponsiblePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Página do Responsável',
          style: TextStyle(
            fontSize: 24, // Tamanho maior da fonte
            fontWeight: FontWeight.bold, // Fonte em negrito
            color: Colors.white, // Cor do texto
            letterSpacing: 1.5, // Espaçamento entre letras
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5), // Cor da sombra
                offset: Offset(2, 2), // Deslocamento da sombra
                blurRadius: 4, // Desfoque da sombra
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blueAccent, // Cor de fundo do cabeçalho
        elevation: 10, // Sombra do cabeçalho
      ),
      backgroundColor: Colors.lightBlue[50], // Cor de fundo da interface
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centraliza os botões verticalmente
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> MedicationLogScreen()),
                      );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // Cor do texto do botão
                  backgroundColor: Colors.blue, // Cor de fundo do botão
                ),
                child: Text('Relatório de Remédios'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  
                  // Adicione a navegação para Relatório de Exercícios
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // Cor do texto do botão
                  backgroundColor: Colors.blue, // Cor de fundo do botão
                ),
                child: Text('Relatório de Exercícios'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> AlertPage()),
                      );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // Cor do texto do botão
                  backgroundColor: Colors.red, // Cor de fundo do botão
                ),
                child: Text('Emergência'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Adicione a navegação para Adicionar Remédios
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // Cor do texto do botão
                  backgroundColor: Colors.green, // Cor de fundo do botão
                ),
                child: Text('Adicionar Remédios'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Adicione a navegação para Registrar Consulta
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // Cor do texto do botão
                  backgroundColor: Colors.orange, // Cor de fundo do botão
                ),
                child: Text('Registrar Consulta'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Adicione a navegação para Consultas Agendadas
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // Cor do texto do botão
                  backgroundColor: Colors.purple, // Cor de fundo do botão
                ),
                child: Text('Consultas Agendadas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
