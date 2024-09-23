import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFECECEC), // Recuadro gris claro
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(24.0), // Espacio interno del recuadro
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign Up!',
                    style: TextStyle(
                      fontSize: 28,
                      color: Color(0xFF012826),
                      fontWeight: FontWeight.bold,
                    ), // Título en verde oscuro
                  ),
                  SizedBox(height: 20),
                  TextField(
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
                  SizedBox(height: 12),
                  TextField(
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
                  SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Name',
                      filled: true,
                      fillColor: Colors.white, // Fondo blanco de las cajas de texto
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Address',
                      filled: true,
                      fillColor: Colors.white, // Fondo blanco de las cajas de texto
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Phone',
                      filled: true,
                      fillColor: Colors.white, // Fondo blanco de las cajas de texto
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight, // Botón alineado a la derecha
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF007451), // Botón verde lima
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      ),
                      onPressed: () {
                        // Lógica para registrar
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ), // Texto del botón en blanco
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
