import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF012826), // Fondo
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign Up!',
              style: TextStyle(fontSize: 32, color: Colors.white), // Título
            ),
            SizedBox(height: 40),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Color(0xFF007451), // Verde más claro
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Color(0xFF007451), // Verde más claro
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Color(0xFF007451), // Verde más claro
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Address',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Color(0xFF007451), // Verde más claro
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Color(0xFF007451), // Verde más claro
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF007451), // Color del botón
              ),
              onPressed: () {
                // Lógica para registrar
                Navigator.pushNamed(context, '/profile');
              },
              child: Text('Register', style: TextStyle(color: Colors.white)), // Color del texto
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login'); // Redirigir a login
              },
              child: Text(
                'Already have an account? Login',
                style: TextStyle(color: Colors.white), // Color del texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
