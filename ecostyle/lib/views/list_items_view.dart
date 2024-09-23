import 'package:flutter/material.dart';

class ListItemsView extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {
      'title': 'Item 1',
      'price': 120000,
      'image': 'assets/images/uniandes_sweater.png',
    },
    {
      'title': 'Item 1',
      'price': 120000,
      'image': 'assets/images/uniandes_sweater.png',
    },
    {
      'title': 'Item 1',
      'price': 120000,
      'image': 'assets/images/uniandes_sweater.png',
    },
    {
      'title': 'Item 1',
      'price': 120000,
      'image': 'assets/images/uniandes_sweater.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF012826), // Color de fondo del AppBar
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {},
            ),
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
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Número de columnas en el grid
            childAspectRatio: 0.7, // Ajustar el ratio de los ítems para hacerlos más pequeños
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              onTap: () {
                // Navega a la vista de detalles cuando se presiona un ítem
                Navigator.pushNamed(context, '/detail', arguments: item);
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Image.asset(
                          item['image'],
                          fit: BoxFit.contain, // Ajustar el tamaño de la imagen
                          width: MediaQuery.of(context).size.width * 0.4, // Ajusta el ancho de la imagen al 40% del ancho de la pantalla
                          height: MediaQuery.of(context).size.height * 0.2, // Ajusta el alto de la imagen al 20% del alto de la pantalla
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '\$ ${item['price']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Uniandes hoodie', style: TextStyle(color: Colors.grey)),
                          Icon(Icons.favorite_border, color: Colors.grey),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
