import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final LocalAuthentication localAuth = LocalAuthentication();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final TextEditingController _emailController = TextEditingController();
  String? password; // Optional password variable
  bool isBiometricLogin = false; // Flag to track login method

  @override
  void initState() {
    super.initState();
    _loadEmail(); // Load stored email when the view initializes
  }

  Future<void> _loadEmail() async {
    final cachedEmail = await secureStorage.read(key: 'userEmail');
    if (cachedEmail != null) {
      _emailController.text = cachedEmail; // Set the retrieved email value
    }
  }

  Future<void> _loginWithEmailAndPassword(BuildContext context, String email, String password) async {
    // Validate email and password
    if (email.isEmpty) {
      _showError(context, 'Email cannot be empty');
      return;
    } else if (!_isValidEmail(email)) {
      _showError(context, 'Invalid email format. Ensure it does not contain spaces and follows "example@domain.com" format');
      return;
    }

    if (password == null && !isBiometricLogin) {
      _showError(context, 'Password cannot be empty');
      return;
    } else if (password != null && !_isValidPassword(password!) && !isBiometricLogin) {
      _showError(context, 'Password must be at least 8 characters long and contain no spaces');
      return;
    }

    try {
      // Attempt to sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password?.trim() ?? '', // Handle null safely
      );

      // Store user email and password securely
      await secureStorage.write(key: 'userEmail', value: email);
      if (password != null) {
        await secureStorage.write(key: 'userPassword', value: password!); // Save the password securely
      }
      await secureStorage.write(key: 'hasLoggedIn', value: 'true'); // Set the logged in flag

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
    try {
      // Check if biometrics are available
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        _showError(context, 'Biometric authentication is not available on this device.');
        return;
      }

      // Prompt for biometric authentication
      bool authenticated = await localAuth.authenticate(
        localizedReason: 'Please authenticate to log in',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        final cachedEmail = await secureStorage.read(key: 'userEmail');
        final cachedPassword = await secureStorage.read(key: 'userPassword'); // Retrieve the password

        if (cachedEmail != null && cachedPassword != null) {
          await analytics.logEvent(
            name: 'user_login_biometrics',
            parameters: {'timestamp': DateTime.now().millisecondsSinceEpoch},
          );
          // Automatically log in the user with cached email and password
          _loginWithEmailAndPassword(context, cachedEmail, cachedPassword); // Use the cached password
        } else {
          _showError(context, 'No cached data found. Please log in with email and password first.');
        }
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
                    controller: _emailController, // Set the controller for the email field
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
                    onChanged: (value) => password = value.isNotEmpty ? value : null, // Set password value
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
                            isBiometricLogin = false; // Set the flag for email/password login
                            // Check if email or password is empty before logging in
                            if (_emailController.text.isEmpty) {
                              _showError(context, 'Email cannot be empty');
                            } else if (password == null) {
                              _showError(context, 'Password cannot be empty');
                            } else {
                              _loginWithEmailAndPassword(context, _emailController.text, password!);
                            }
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
                  if (Platform.isIOS) // Check if the platform is iOS
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007451),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        isBiometricLogin = true; // Set the flag for biometric login
                        _authenticateWithBiometrics(context);
                      },
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
