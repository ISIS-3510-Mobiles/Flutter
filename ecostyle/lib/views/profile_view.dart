import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  final String name = "User Name"; // Aquí puedes obtener el nombre real
  final String email = "email@example.com"; // Aquí puedes obtener el correo real
  final String phone = "123456789"; // Aquí puedes obtener el teléfono real
  final String address = "Address of the user"; // Aquí puedes obtener la dirección real

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      backgroundColor: Color(0xFF012826), // Color de fondo oscuro
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Centrar todos los elementos
            children: [
              CircleAvatar(
                radius: 50, // Tamaño del avatar
                backgroundColor: Colors.grey, // Color de fondo del avatar
                child: Icon(Icons.person, size: 50, color: Colors.white), // Icono de usuario
              ),
              SizedBox(height: 16), // Espacio entre la foto y el texto
              Text("Name: $name", style: TextStyle(color: Colors.white)),
              SizedBox(height: 8),
              Text("Email: $email", style: TextStyle(color: Colors.white)),
              SizedBox(height: 8),
              Text("Phone: $phone", style: TextStyle(color: Colors.white)),
              SizedBox(height: 8),
              Text("Address: $address", style: TextStyle(color: Colors.white)),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register'); // Navegar a la vista de registro
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF007451)), // Color del botón
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0)), // Espaciado del botón
                ),
                child: Text(
                  'Update Info',
                  style: TextStyle(color: Colors.white), // Color del texto
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
