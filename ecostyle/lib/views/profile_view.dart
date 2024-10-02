import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart'; 
import 'change_password_view.dart';

class ProfileView extends StatelessWidget {
  final String name = "Armando Casas"; // Nombre real
  final String email = "lorem@uniandes.edu.co"; // Correo real
  final String phone = "123-456-7890"; // Teléfono real
  final String address = "Cra 123 #45-67"; // Dirección real

  const ProfileView({super.key});

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
        child: Padding(
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
                name, 
                style: const TextStyle(
                  fontSize: 28.8, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 9.6), 
              Text(
                email, 
                style: TextStyle(
                  fontSize: 21.6, 
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 9.6),
              Text(
                phone,
                style: TextStyle(
                  fontSize: 21.6,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 9.6),
              Text(
                address,
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
                  backgroundColor: WidgetStateProperty.all(const Color(0xFF007451)), // Color verde lima
                  padding: WidgetStateProperty.all(
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
                  backgroundColor: WidgetStateProperty.all(const Color(0xFF007451)), // Color verde lima
                  padding: WidgetStateProperty.all(
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
        ),
      ),
    );
  }
}
