import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  Future<void> _authenticateWithBiometrics(BuildContext context) async {
    final LocalAuthentication auth = LocalAuthentication();

    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to log in',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        // Si la autenticación es exitosa, navega a la vista del perfil
        Navigator.pushNamed(context, '/profile');
      } else {
        // Manejar el caso donde la autenticación falla
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication failed')),
        );
      }
    } catch (e) {
      // Manejar excepciones
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error authenticating')),
      );
    }
  }

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
              'EcoStyle',
              style: TextStyle(fontSize: 32, color: Colors.white), // Título
            ),
            const SizedBox(height: 40),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF007451), // Cambiado a un verde más claro
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // Ajustar los bordes redondeados
                  borderSide: BorderSide.none, // Sin borde visible
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true, // Para ocultar la contraseña
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF007451), // Cambiado a un verde más claro
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
                // Lógica para iniciar sesión
                Navigator.pushNamed(context, '/profile');
              },
              child: const Text('Login', style: TextStyle(color: Colors.white)), // Color del texto
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007451), // Color del botón
              ),
              onPressed: () {
                _authenticateWithBiometrics(context); // Llama a la autenticación biométrica
              },
              child: const Text('Login with Biometrics', style: TextStyle(color: Colors.white)), // Color del texto
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text(
                'Don\'t have an account? Sign Up',
                style: TextStyle(color: Colors.white), // Color del texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
