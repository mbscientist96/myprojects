
// clinica.dart
// Definindo a classe Clinica que será utilizada em várias partes do aplicativo.

import 'package:flutter/foundation.dart'; // Import necessário para utilizar @required
import 'package:flutter/material.dart'; // Import necessário para usar tipos relacionados ao Flutter (caso precise em outros arquivos)

/// Classe que representa uma clínica.
/// Contém informações básicas como [id], [nome], [telefone] e [horario].
class Clinica {
  final int id;
  final String nome;
  final String telefone;
  final String horario;

  /// Construtor da classe [Clinica].
  /// Todos os parâmetros são obrigatórios ([required]).
  Clinica({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.horario,
  });
}
