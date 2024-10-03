import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Authentication

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instancia de FirebaseAuth

  // Variables para almacenar los datos del usuario
  String email = '';
  String password = '';
  String name = '';
  String address = '';
  String phone = '';

  // Método para registrar al usuario
  Future<void> _registerWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful')),
      );
      // Redirige a la vista de perfil después del registro
      Navigator.pushNamed(context, '/list');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFECECEC), // Recuadro gris claro
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(24.0), // Espacio interno del recuadro
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign Up!',
                    style: TextStyle(
                      fontSize: 28,
                      color: Color(0xFF012826),
                      fontWeight: FontWeight.bold,
                    ), // Título en verde oscuro
                  ),
                  SizedBox(height: 20),
                  TextField(
                    onChanged: (value) => setState(() {
                      email = value;
                    }),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.white, // Fondo blanco de las cajas de texto
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    obscureText: true,
                    onChanged: (value) => setState(() {
                      password = value;
                    }),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.white, // Fondo blanco de las cajas de texto
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    onChanged: (value) => setState(() {
                      name = value;
                    }),
                    decoration: InputDecoration(
                      hintText: 'Name',
                      filled: true,
                      fillColor: Colors.white, // Fondo blanco de las cajas de texto
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    onChanged: (value) => setState(() {
                      address = value;
                    }),
                    decoration: InputDecoration(
                      hintText: 'Address',
                      filled: true,
                      fillColor: Colors.white, // Fondo blanco de las cajas de texto
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    onChanged: (value) => setState(() {
                      phone = value;
                    }),
                    decoration: InputDecoration(
                      hintText: 'Phone',
                      filled: true,
                      fillColor: Colors.white, // Fondo blanco de las cajas de texto
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight, // Botón alineado a la derecha
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF007451), // Botón verde lima
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      ),
                      onPressed: () {
                        // Llama al método de registro con Firebase
                        _registerWithEmailAndPassword();
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ), // Texto del botón en blanco
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
