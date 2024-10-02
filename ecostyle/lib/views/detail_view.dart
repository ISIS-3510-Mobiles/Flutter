import 'package:flutter/material.dart';

class DetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtener los argumentos pasados desde list_items_view.dart
    final Map<String, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final Map<String, dynamic> item = args['item']; // Producto seleccionado
    final List<Map<String, dynamic>> allItems = args['allItems']; // Lista de productos recomendados

    // Obtener recomendaciones basadas en similitud de palabras
    List<Map<String, dynamic>> recommendedItems = _getRecommendedItems(item, allItems);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF012826),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search in EcoStyle',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
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
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView( // Scroll vertical
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                item['image'], // Usamos la imagen del producto seleccionado
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              Text(
                item['title'], // Título del producto
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 10),
              Text(
                '\$ ${item['price']}', // Precio del producto
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 10),
              Text(
                item['description'], // Descripción del producto
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              IconButton(
                icon: Icon(Icons.favorite_border),
                color: Colors.black54,
                onPressed: () {
                  // Lógica para agregar a favoritos
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF007451),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                ),
                onPressed: () {
                  // Lógica para comprar
                },
                child: Text(
                  'Buy now',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7FB9A8),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                ),
                onPressed: () {
                  // Lógica para agregar al carrito
                },
                child: Text(
                  'Add to cart',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Similar products:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 10),
              // Scroll horizontal para productos similares
              SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Scroll horizontal
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(recommendedItems.length, (index) {
                    final recommendedItem = recommendedItems[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Image.asset(
                            recommendedItem['image'],
                            height: 80,
                          ),
                          SizedBox(height: 5),
                          Text(recommendedItem['title']),
                          SizedBox(height: 5),
                          Text('\$ ${recommendedItem['price']}'),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Función para obtener los productos recomendados
  List<Map<String, dynamic>> _getRecommendedItems(Map<String, dynamic> currentItem, List<Map<String, dynamic>> allItems) {
    String title = currentItem['title'].toLowerCase();
    List<Map<String, dynamic>> similarItems = [];
    
    // Buscar productos con palabras similares
    List<String> words = title.split(' ');
    int index = 0;
    bool found = false;

    while (index < words.length && !found) {
      String word = words.elementAt(index);
      for (var item in allItems) {
        if (item['title'] != currentItem['title'] && item['title'].toLowerCase().contains(word)) {
          bool selected = false;
          for (Map<String, dynamic> itemSelected in similarItems) {
            if (itemSelected['title'] == item['title']) {
              selected = true;
            }
          }
          if (!selected) {
            similarItems.add(item);
          }
        }
      }
      if (similarItems.length >= 2) {
        found = true;
      } 
      index++;
    }

    if (similarItems.isNotEmpty) {
      // Ordenar por precio
      if (similarItems.length < 3) {
        List<Map<String, dynamic>> listItems = [];
        for (Map<String, dynamic> item in allItems) {
          listItems.add(item);
        }
        listItems.sort((a, b) => a['price'].compareTo(b['price'])); // Ordenar por precio
        bool selected = false;
        int index = 0;
        while (!selected) {
          Map<String, dynamic> item = listItems.elementAt(index);
          bool alreadySelected = false;
          for(Map<String, dynamic> itemSelected in similarItems) {
            if (itemSelected['title'].toLowerCase() == item['title'].toLowerCase() || item['title'] == currentItem['title']) {
              alreadySelected = true;
            }
          }
          if (alreadySelected == true) {
            index++;
          }
          else {
            selected = true;
            similarItems.add(item);
          }
        }
      }
      similarItems.sort((a, b) => a['price'].compareTo(b['price']));
      return similarItems.take(3).toList(); // Retornamos los 3 más baratos
    } else {
      // Si no hay productos similares, buscar los más cercanos (ya implementados antes)
      List<Map<String, dynamic>> listItems = [];
      for (Map<String, dynamic> item in allItems) {
        listItems.add(item);
      }
      listItems.sort((a, b) => a['price'].compareTo(b['price'])); // Ordenar por precio
      return listItems.take(3).toList(); // Retornamos los 3 más cercanos por precio
    }
  }
}
