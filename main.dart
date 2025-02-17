import 'package:flutter/material.dart';
import 'register_page.dart'; 
import 'responsible_page.dart'; 
import 'idoso_page.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; 
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'medication_channel',
        channelName: 'Lembretes de Medicação',
        channelDescription: 'Notificações para lembrar de tomar os remédios',
        defaultColor: Colors.teal,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
    ],
    debug: true,
  );

  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assistência Idosos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (userDoc.exists) {
        String role = userDoc.data()?['role'] ?? '';

        if (role == 'Responsável') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ResponsiblePage()),
          );
        } else if (role == 'Idoso') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AssistenciaApp()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Role não identificado')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário não encontrado no sistema')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login: ${e.toString()}')),
      );
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bem-vindo à Assistência',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40),
                Text(
                  'Acesse sua conta',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black26,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                _buildTextField(
                  controller: emailController,
                  label: 'Email',
                  icon: Icons.email,
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: passwordController,
                  label: 'Senha',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.teal, backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 6,
                  ),
                  child: Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _navigateToRegister,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.teal, backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 6,
                  ),
                  child: Text(
                    'Cadastre-se',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
  }) {
    return TextField(
      controller: controller,
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
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
    );
  }
}
