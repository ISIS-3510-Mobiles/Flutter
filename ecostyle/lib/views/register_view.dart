import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF012826), // Fondo
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign Up!',
              style: TextStyle(fontSize: 32, color: Colors.white), // Título
            ),
            const SizedBox(height: 40),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF007451), // Verde más claro
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF007451), // Verde más claro
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF007451), // Verde más claro
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Address',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF007451), // Verde más claro
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF007451), // Verde más claro
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007451), // Color del botón
              ),
              onPressed: () {
                // Lógica para registrar
                Navigator.pushNamed(context, '/profile');
              },
              child: const Text('Register', style: TextStyle(color: Colors.white)), // Color del texto
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login'); // Redirigir a login
              },
              child: const Text(
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
