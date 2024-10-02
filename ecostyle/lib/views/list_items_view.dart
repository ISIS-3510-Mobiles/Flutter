import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // Usar esta librería para funciones de listas

class ListItemsView extends StatefulWidget {
  @override
  _ListItemsViewState createState() => _ListItemsViewState();
}

class _ListItemsViewState extends State<ListItemsView> {
  final List<Map<String, dynamic>> original_items = [
    {'title': 'Sporty Jacket', 'price': 120000, 'image': 'assets/images/sporty_jacket.png'},
    {'title': 'Yellow Beauty Jacket', 'price': 150000, 'image': 'assets/images/yellow_beauty_jacket.png'},
    {'title': 'Uniandes Hoodie', 'price': 80000, 'image': 'assets/images/uniandes_sweater.png'},
    {'title': 'Simple Uniandes Jacket', 'price': 130000, 'image': 'assets/images/uniandes_jacket.png'},
    {'title': 'Uniandes red Cap', 'price': 50000, 'image': 'assets/images/uniandes_cap.png'},
    {'title': 'I love 4:20 Cap', 'price': 60000, 'image': 'assets/images/420_cap.png'},
    {'title': 'Grey Sporty Cap', 'price': 130000, 'image': 'assets/images/grey_sporty_cap.png'},
  ];

  List<Map<String, dynamic>> items = [
    {'title': 'Sporty Jacket', 'price': 120000, 'image': 'assets/images/sporty_jacket.png'},
    {'title': 'Yellow Beauty Jacket', 'price': 150000, 'image': 'assets/images/yellow_beauty_jacket.png'},
    {'title': 'Uniandes Hoodie', 'price': 80000, 'image': 'assets/images/uniandes_sweater.png'},
    {'title': 'Simple Uniandes Jacket', 'price': 130000, 'image': 'assets/images/uniandes_jacket.png'},
    {'title': 'Uniandes red Cap', 'price': 50000, 'image': 'assets/images/uniandes_cap.png'},
    {'title': 'I love 4:20 Cap', 'price': 60000, 'image': 'assets/images/420_cap.png'},
    {'title': 'Grey Sporty Cap', 'price': 130000, 'image': 'assets/images/grey_sporty_cap.png'},
  ];

  List<Map<String, dynamic>> recentlyViewedItems = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF012826),
        title: Row(
          children: [
            IconButton(icon: Icon(Icons.menu, color: Colors.white), onPressed: () {}),
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
            IconButton(icon: Icon(Icons.shopping_cart, color: Colors.white), onPressed: () {}),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            childAspectRatio: 0.7, 
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              onTap: () {
                // Navega a la vista de detalles y agrega el ítem a la lista de últimos vistos, también actualiza la lista de items
                _viewItem(context, item);
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
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['title'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '\$ ${item['price']}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  void _viewItem(BuildContext context, Map<String, dynamic> item) {
    setState(() {
      // Agrega el producto a la lista de últimos vistos
      if (recentlyViewedItems.length >= 5) {
        recentlyViewedItems.removeAt(0); // Elimina el más antiguo si ya hay 5
      }
      recentlyViewedItems.add(item);
      
      List<String> titleItems = [];
      for (Map<String, dynamic> item in recentlyViewedItems) {
        titleItems.add(item['title']);
      }
      print(titleItems);
      // Chequea si hay al menos 3 ítems con títulos similares
      String commonWord = _findCommonWord(titleItems);
      if (commonWord.isNotEmpty) {
        // Reorganiza los elementos con la palabra común
        List<Map<String, dynamic>> sameItems = [];
        List<Map<String, dynamic>> otherItems = [];
        for (Map<String, dynamic> item in original_items) {
          String itemTitle = item['title'].toLowerCase();
          if (itemTitle.contains(commonWord)) {
            sameItems.add(item);
          } 
          else {
            otherItems.add(item);
          }
        }

        items = [];
        for (Map<String, dynamic> item in sameItems) {
          items.add(item);
        }
        for (Map<String, dynamic> item in otherItems) {
          items.add(item);
        }

      }
      else {
        items = original_items;
      }
    });
    
    // Navegar a la vista de detalles
    Navigator.pushNamed(context, '/detail', arguments: item);
  }

  String _findCommonWord(List<String> titles) {
    Map<String, int> wordFrequency = {};
    for (String title in titles) {
      List<String> words = title.toLowerCase().split(' ');
      for (String word in words) {
        wordFrequency[word] = (wordFrequency[word] ?? 0) + 1;
      }
    }

    // Encuentra la palabra que aparece en al menos 3 títulos
    String? commonWord = wordFrequency.entries.firstWhereOrNull((entry) => entry.value >= 3)?.key;
    print(commonWord);
    return commonWord ?? '';
  }
}
