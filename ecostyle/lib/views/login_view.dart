import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key}); // Constructor no constante

  // Instancia de FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance; // Instancia de FirebaseAnalytics

  Future<void> _loginWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Registrar evento de inicio de sesión
      await analytics.logEvent(
        name: 'user_login',
        parameters: {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      // Si el inicio de sesión es exitoso, navega a la vista de la lista
      Navigator.pushNamed(context, '/list');
    } on FirebaseAuthException catch (e) {
      // Manejar errores de autenticación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
  }

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
        // Registrar evento de inicio de sesión
        await analytics.logEvent(
          name: 'user_login_biometrics',
          parameters: {
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          },
        );
        // Si la autenticación es exitosa, navega a la vista de la lista
        Navigator.pushNamed(context, '/list');
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
    String email = '';
    String password = '';

    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFECECEC), // Recuadro gris claro
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(24.0), // Espacio interno del recuadro
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'EcoStyle',
                    style: TextStyle(
                      fontSize: 32,
                      color: const Color(0xFF012826),
                      fontWeight: FontWeight.bold,
                    ), // Título en verde oscuro
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (value) => email = value, // Guardar el email
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
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: (value) => password = value, // Guardar la contraseña
                    obscureText: true,
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
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007451), // Botón verde lima
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            // Lógica para iniciar sesión con correo y contraseña
                            _loginWithEmailAndPassword(context, email, password);
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ), // Texto del botón en blanco
                        ),
                      ),
                      const SizedBox(width: 10), // Espacio entre los botones
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007451), // Botón verde lima
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ), // Texto del botón en blanco
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007451), // Botón verde lima
                      padding: const EdgeInsets.symmetric(vertical: 16), // Ajustar el tamaño del botón
                    ),
                    onPressed: () => _authenticateWithBiometrics(context), // Autenticación biométrica
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.face, color: Colors.white), // Icono de FaceID
                        const SizedBox(width: 8), // Espacio entre el icono y el texto
                        const Text(
                          'FaceID', // Texto del botón
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ), // Texto del botón en blanco
                      ],
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
