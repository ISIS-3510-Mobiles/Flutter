import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart'; 
import 'change_password_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, String>> _fetchUserData() async {
    User? user = _auth.currentUser; // Obtiene el usuario autenticado
    Map<String, String> userData = {
      'name': '',
      'phone': '',
      'address': '',
    };

    if (user != null) {
      // Busca el documento correspondiente al usuario en Firestore
      DocumentSnapshot userDoc = await _firestore.collection('User').doc(user.email).get();

      if (userDoc.exists) {
        userData['name'] = userDoc['name'] ?? ''; // Asegúrate de que los campos en Firestore coincidan
        userData['phone'] = userDoc['phone'] ?? '';
        userData['address'] = userDoc['address'] ?? '';
      }
    }

    return userData; // Retorna los datos del usuario
  }

  Future<void> authenticate(BuildContext context) async {
    final LocalAuthentication localAuth = LocalAuthentication();
    bool authenticated = false;

    try {
      authenticated = await localAuth.authenticate(
        localizedReason: 'Please authenticate to change your password',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (e) {
      // Manejar el error, como mostrar un snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication failed')),
      );
    }

    if (authenticated) {
      // Si la autenticación es exitosa, navegar a ChangePasswordView
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChangePasswordView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF012826), // Fondo verde oscuro
        elevation: 0, // Eliminar sombra
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white), // Icono de menú blanco
          onPressed: () {
            // Lógica para abrir el menú
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white), // Icono del carrito blanco
            onPressed: () {
              // Acción del carrito
            },
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            height: 48, 
            decoration: BoxDecoration(
              color: Colors.white, // Fondo blanco de la barra de búsqueda
              borderRadius: BorderRadius.circular(8), // Bordes redondeados
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search in EcoStyle',
                hintStyle: TextStyle(color: Colors.grey), // Texto gris en la barra de búsqueda
                border: InputBorder.none, // Sin bordes
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white, // Fondo blanco
      body: Center(
        child: FutureBuilder<Map<String, String>>(
          future: _fetchUserData(), // Llama a la función para obtener datos
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Muestra un indicador de carga
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final userData = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center, // Centrar los elementos
                  children: [
                    const SizedBox(height: 24), 
                    const Text(
                      'Profile', // Cambiado a inglés
                      style: TextStyle(
                        fontSize: 38.4, 
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF012826), // Verde oscuro para resaltar
                      ),
                    ),
                    const SizedBox(height: 24), 
                    const CircleAvatar(
                      radius: 72, 
                      backgroundImage: AssetImage('assets/images/profile_image.png'), // Ruta dentro de assets
                    ),
                    const SizedBox(height: 19.2), 
                    Text(
                      userData['name']!.isEmpty ? 'Loading...' : userData['name']!, // Muestra un texto de carga
                      style: const TextStyle(
                        fontSize: 28.8, 
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 9.6), 
                    Text(
                      userData['phone']!.isEmpty ? 'Loading...' : userData['phone']!, // Muestra un texto de carga
                      style: TextStyle(
                        fontSize: 21.6,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 9.6),
                    Text(
                      userData['address']!.isEmpty ? 'Loading...' : userData['address']!, // Muestra un texto de carga
                      style: TextStyle(
                        fontSize: 21.6,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 36), 

                    // Botón para actualizar datos
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register'); // Navegar a la vista de registro
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color(0xFF007451)), // Color verde lima
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 14.4, horizontal: 48), 
                        ), // Espaciado del botón
                      ),
                      child: const Text(
                        'Update Info',
                        style: TextStyle(
                          fontSize: 19.2, 
                          color: Colors.white,
                        ), // Texto blanco
                      ),
                    ),
                    
                    const SizedBox(height: 24), 

                    // Botón para cambiar contraseña con autenticación biométrica
                    ElevatedButton(
                      onPressed: () => authenticate(context),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color(0xFF007451)), // Color verde lima
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 14.4, horizontal: 48), 
                        ),
                      ),
                      child: const Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 19.2, 
                          color: Colors.white,
                        ), // Texto blanco
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No data found'));
            }
          },
        ),
      ),
    );
  }
}
