import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  String email = '';
  String password = '';
  String name = '';
  String address = '';
  String phone = '';

  // Method to show error messages
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Validation functions with error messages
  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email) || email.contains(' ')) {
      _showErrorMessage('Invalid email format. Please enter a valid email address.');
      return false;
    }
    return true;
  }

  bool _validatePassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');
    if (!passwordRegex.hasMatch(password) || password.contains(' ')) {
      _showErrorMessage('Password must be at least 8 characters long and include uppercase, lowercase, a digit, and a special character without spaces.');
      return false;
    }
    return true;
  }

  bool _validateName(String name) {
    final nameRegex = RegExp(r'^[a-zA-Z\s]{2,50}$');
    if (!nameRegex.hasMatch(name)) {
      _showErrorMessage('Name should only contain letters and spaces, and be between 2 and 50 characters.');
      return false;
    }
    return true;
  }

  bool _validateAddress(String address) {
    final addressRegex = RegExp(r'^[a-zA-Z0-9\s,.-]{5,100}$');
    if (!addressRegex.hasMatch(address) || RegExp(r'^\d+$').hasMatch(address)) {
      _showErrorMessage('Address must be between 5 and 100 characters and not contain only numbers.');
      return false;
    }
    return true;
  }

  bool _validatePhone(String phone) {
    final phoneRegex = RegExp(r'^[1-9]\d{9}$');
    if (!phoneRegex.hasMatch(phone)) {
      _showErrorMessage('Phone number should be 10 digits long and cannot start with 0.');
      return false;
    }
    return true;
  }

  // Method to register the user
  Future<void> _registerWithEmailAndPassword() async {
  if (_validateEmail(email) &&
      _validatePassword(password) &&
      _validateName(name) &&
      _validateAddress(address) &&
      _validatePhone(phone)) {
    try {
      // Registra al usuario
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guarda la información del usuario en Firestore
      await _firestore.collection('User').doc(email).set({
        'name': name,
        'address': address,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(), // Guarda la fecha y hora del registro
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful')),
      );

      // Navegar a la pantalla de perfil
      Navigator.pushNamed(context, '/profile');
    } on FirebaseAuthException catch (e) {
      _showErrorMessage('Error: ${e.message}');
    }
  } else {
    _showErrorMessage('Please check your input for errors.');
  }
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
                color: Color(0xFFECECEC),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign Up!',
                    style: TextStyle(
                      fontSize: 28,
                      color: Color(0xFF012826),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    onChanged: (value) => setState(() {
                      email = value;
                    }),
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
                  SizedBox(height: 12),
                  TextField(
                    obscureText: true,
                    onChanged: (value) => setState(() {
                      password = value;
                    }),
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
                  SizedBox(height: 12),
                  TextField(
                    onChanged: (value) => setState(() {
                      name = value;
                    }),
                    decoration: InputDecoration(
                      hintText: 'Name',
                      filled: true,
                      fillColor: Colors.white,
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
                      fillColor: Colors.white,
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
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF007451),
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      ),
                      onPressed: () {
                        _registerWithEmailAndPassword();
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
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
