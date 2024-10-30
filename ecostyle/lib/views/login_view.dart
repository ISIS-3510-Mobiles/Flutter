import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> _loginWithEmailAndPassword(BuildContext context, String email, String password) async {
    // Check if email is empty or invalid
    if (email.isEmpty) {
      _showError(context, 'Email cannot be empty');
      return;
    } else if (!_isValidEmail(email)) {
      _showError(context, 'Invalid email format. Ensure it does not contain spaces and follows "example@domain.com" format');
      return;
    }

    // Check if password is empty or too short
    if (password.isEmpty) {
      _showError(context, 'Password cannot be empty');
      return;
    } else if (!_isValidPassword(password)) {
      _showError(context, 'Password must be at least 8 characters long and contain no spaces');
      return;
    }

    try {
      // Attempt to sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Log successful login event
      await analytics.logEvent(
        name: 'user_login',
        parameters: {'timestamp': DateTime.now().millisecondsSinceEpoch},
      );

      // Navigate to list view on successful login
      Navigator.pushNamed(context, '/list');
    } on FirebaseAuthException catch (e) {
      _showError(context, 'Login failed: ${e.message}');
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
        await analytics.logEvent(
          name: 'user_login_biometrics',
          parameters: {'timestamp': DateTime.now().millisecondsSinceEpoch},
        );
        Navigator.pushNamed(context, '/list');
      } else {
        _showError(context, 'Authentication failed. Please try again.');
      }
    } catch (e) {
      _showError(context, 'Error authenticating. Please try again.');
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email) && !email.contains(' ');
  }

  bool _isValidPassword(String password) {
    return password.trim().isNotEmpty && password.length >= 8;
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    String email = '';
    String password = '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFECECEC),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'EcoStyle',
                    style: TextStyle(
                      fontSize: 32,
                      color: const Color(0xFF012826),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (value) => email = value,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: (value) => password = value,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
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
                            backgroundColor: const Color(0xFF007451),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            _loginWithEmailAndPassword(context, email, password);
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007451),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007451),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _authenticateWithBiometrics(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.face, color: Colors.white),
                        const SizedBox(width: 8),
                        const Text(
                          'FaceID',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
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
