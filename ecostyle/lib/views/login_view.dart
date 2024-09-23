import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'EcoStyle',
                    style: TextStyle(
                      fontSize: 32,
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
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF007451), // Botón verde lima
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            // Lógica para iniciar sesión
                            Navigator.pushNamed(context, '/profile');
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ), // Texto del botón en blanco
                        ),
                      ),
                      SizedBox(width: 10), // Espacio entre los botones
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF007451), // Botón verde lima
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ), // Texto del botón en blanco
                        ),
                      ),
                    ],
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
