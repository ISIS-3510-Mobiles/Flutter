import 'package:flutter/material.dart';

class DetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF012826), // Color de fondo del AppBar
        title: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search in EcoStyle',
                  prefixIcon: Icon(Icons.search, color:Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart, color:Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen del producto con ajuste de tamaño
            Image.asset(
              'assets/images/uniandes_sweater.png', // Coloca aquí la ruta correcta de tu imagen
              height: MediaQuery.of(context).size.height * 0.4, // Ajusta al 40% del alto de la pantalla
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            // Texto de nombre del producto
            Text(
              'Uniandes hoodie',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 10),
            // Texto de precio del producto
            Text(
              '\$ 120 000',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 10),
            // Texto de descripción del producto
            Text(
              "Uniandes Hoodie XL size. I changed Nacho's university, so I no longer use the hoodie.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Icono de agregar a favoritos
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  color: Colors.black54,
                  onPressed: () {
                    // Lógica para agregar a favoritos
                  },
                ),
              ],
            ),
            Spacer(),
            // Botón de comprar con ajuste de tamaño
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF007451), // Color del botón de comprar
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
              ),
              onPressed: () {
                // Lógica para comprar
              },
              child: Text(
                'Buy',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(height: 10),
            // Botón de agregar al carrito con ajuste de tamaño
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7FB9A8), // Color del botón de agregar al carrito
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
              ),
              onPressed: () {
                // Lógica para agregar al carrito
              },
              child: Text(
                'Add to Cart',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
