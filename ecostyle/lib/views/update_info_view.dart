import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class UpdateInfoView extends StatefulWidget {
  const UpdateInfoView({super.key});

  @override
  _UpdateInfoViewState createState() => _UpdateInfoViewState();
}

class _UpdateInfoViewState extends State<UpdateInfoView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String email = '';
  String name = '';
  String address = '';
  String phone = '';

  // Controllers for editable fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentUserInfo();
  }

  Future<void> _loadCurrentUserInfo() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('User').doc(user.email).get();
      if (userDoc.exists) {
        setState(() {
          email = user.email!;
          name = userDoc['name'];
          address = userDoc['address'];
          phone = userDoc['phone'];

          nameController.text = name;
          addressController.text = address;
          phoneController.text = phone;
        });
      }
    }
  }

  // Method to check internet connection
  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showErrorMessage('No internet connection. Please try again later.');
      return false;
    }
    return true;
  }

  // Method to show error messages
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Validation functions
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

  // Method to update user info
  Future<void> _updateUserInfo() async {
    if (_validateName(name) && _validateAddress(address) && _validatePhone(phone)) {
      if (await _checkInternetConnection()) {  // Check for internet connection
        try {
          User? user = _auth.currentUser;

          if (user != null) {
            await _firestore.collection('User').doc(user.email).update({
              'name': name,
              'address': address,
              'phone': phone,
            });

            _showErrorMessage('Information updated successfully!');
            Navigator.pop(context);
          }
        } catch (e) {
          _showErrorMessage('Error: ${e.toString()}');
        }
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
                    'Update Info',
                    style: TextStyle(
                      fontSize: 28,
                      color: Color(0xFF012826),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    controller: TextEditingController(text: email),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: nameController,
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
                    controller: addressController,
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
                    controller: phoneController,
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
                        _updateUserInfo();
                      },
                      child: Text(
                        'Update',
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
