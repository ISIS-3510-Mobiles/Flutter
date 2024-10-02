import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  final String name = "Armando Casas"; // Nombre real
  final String email = "lorem@uniandes.edu.co"; // Correo real

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF012826), // Fondo verde oscuro
        elevation: 0, // Eliminar sombra
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white), // Icono de menú blanco
          onPressed: () {
            // Lógica para abrir el menú
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white), // Icono del carrito blanco
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
            child: TextField(
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
              SizedBox(height: 24), 
              Text(
                'Profile', // Cambiado a inglés
                style: TextStyle(
                  fontSize: 38.4, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF012826), // Verde oscuro para resaltar
                ),
              ),
              SizedBox(height: 24), 
              CircleAvatar(
               radius: 72, 
                backgroundImage: AssetImage('assets/images/profile_image.png'), // Ruta dentro de assets
              ),

              SizedBox(height: 19.2), 
              Text(
                "$name", 
                style: TextStyle(
                  fontSize: 28.8, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 9.6), 
              Text(
                "$email", 
                style: TextStyle(
                  fontSize: 21.6, 
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 36), 
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register'); // Navegar a la vista de registro
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF007451)), // Color verde lima
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 14.4, horizontal: 48), 
                  ), // Espaciado del botón
                ),
                child: Text(
                  'Update Info',
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
