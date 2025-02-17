import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedRole;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _register() async {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        selectedRole != null) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'name': nameController.text,
          'email': emailController.text,
          'city': cityController.text,
          'role': selectedRole,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cadastro realizado com sucesso')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 33, 32), // Fundo do cabeçalho em azul escuro
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 100,
        title: Text(
          'Cadastro',
          style: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.bold,
            color: Colors.teal[100], // Cor clara para contraste com fundo
            fontFamily: 'Montserrat',
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.tealAccent,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.tealAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  controller: nameController,
                  label: 'Nome',
                  icon: Icons.person,
                ),
                SizedBox(height: 16.0),
                _buildTextField(
                  controller: emailController,
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.0),
                _buildTextField(
                  controller: cityController,
                  label: 'Cidade/Estado',
                  icon: Icons.location_city,
                ),
                SizedBox(height: 16.0),
                _buildTextField(
                  controller: passwordController,
                  label: 'Senha',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Selecione o tipo de usuário',
                    prefixIcon: Icon(Icons.account_circle, color: Colors.teal),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'Idoso',
                      child: Text('Idoso'),
                    ),
                    DropdownMenuItem(
                      value: 'Responsável',
                      child: Text('Responsável'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value;
                    });
                  },
                  iconEnabledColor: Colors.teal,
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Colors.teal,
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 6,
                  ),
                  child: Text(
                    'Cadastrar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}
