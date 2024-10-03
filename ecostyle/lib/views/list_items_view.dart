import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // Usar esta librería para funciones de listas
import 'package:geolocator/geolocator.dart'; // Para obtener la ubicación del usuario
import 'dart:math'; // Para calcular la distancia entre dos puntos
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


class ListItemsView extends StatefulWidget {
  @override
  _ListItemsViewState createState() => _ListItemsViewState();
}

class _ListItemsViewState extends State<ListItemsView> {
  final List<Map<String, dynamic>> original_items = [
    {"title": "Sporty Jacket", "price": 120000, "image": "assets/images/sporty_jacket.png", "latitude": 4.6351, "longitude": -74.0703, "description": "Sporty Jacket size L. I bought it for a trip but never ended up using it.", "category": "Jacket"},
    {"title": "Yellow Beauty Jacket", "price": 150000, "image": "assets/images/yellow_beauty_jacket.png", "latitude": 4.6097, "longitude": -74.0817, "description": "Yellow Beauty Jacket size M. I love the color, but it's not my style anymore.", "category": "Jacket"},
    {"title": "Uniandes Hoodie", "price": 80000, "image": "assets/images/uniandes_sweater.png", "latitude": 4.6370, "longitude": -74.0824, "description": "Uniandes Hoodie size XL. I changed to Nacho's university, so I don't use it anymore.", "category": "Hoodie"},
    {"title": "Simple Uniandes Jacket", "price": 130000, "image": "assets/images/uniandes_jacket.png", "latitude": 4.6000, "longitude": -74.0721, "description": "Simple Uniandes Jacket size L. I received it as a gift, but it's not my color.", "category": "Jacket"},
    {"title": "Uniandes Red Cap", "price": 50000, "image": "assets/images/uniandes_cap.png", "latitude": 4.6097, "longitude": -74.0817, "description": "Uniandes Red Cap. I bought it during my first year, but I rarely wear caps.", "category": "Cap"},
    {"title": "I Love 4:20 Cap", "price": 60000, "image": "assets/images/420_cap.png", "latitude": 4.6351, "longitude": -74.0703, "description": "I Love 4:20 Cap. It's a fun cap, but I don't wear it often.", "category": "Cap"},
    {"title": "Grey Sporty Cap", "price": 130000, "image": "assets/images/grey_sporty_cap.png", "latitude": 4.6370, "longitude": -74.0824, "description": "Grey Sporty Cap. I bought it for outdoor activities, but I prefer other styles now.", "category": "Cap"}
];

  List<Map<String, dynamic>> items = [
    {"title": "Sporty Jacket", "price": 120000, "image": "assets/images/sporty_jacket.png", "latitude": 4.6351, "longitude": -74.0703, "description": "Sporty Jacket size L. I bought it for a trip but never ended up using it.", "category": "Jacket"},
    {"title": "Yellow Beauty Jacket", "price": 150000, "image": "assets/images/yellow_beauty_jacket.png", "latitude": 4.6097, "longitude": -74.0817, "description": "Yellow Beauty Jacket size M. I love the color, but it's not my style anymore.", "category": "Jacket"},
    {"title": "Uniandes Hoodie", "price": 80000, "image": "assets/images/uniandes_sweater.png", "latitude": 4.6370, "longitude": -74.0824, "description": "Uniandes Hoodie size XL. I changed to Nacho's university, so I don't use it anymore.", "category": "Hoodie"},
    {"title": "Simple Uniandes Jacket", "price": 130000, "image": "assets/images/uniandes_jacket.png", "latitude": 4.6000, "longitude": -74.0721, "description": "Simple Uniandes Jacket size L. I received it as a gift, but it's not my color.", "category": "Jacket"},
    {"title": "Uniandes Red Cap", "price": 50000, "image": "assets/images/uniandes_cap.png", "latitude": 4.6097, "longitude": -74.0817, "description": "Uniandes Red Cap. I bought it during my first year, but I rarely wear caps.", "category": "Cap"},
    {"title": "I Love 4:20 Cap", "price": 60000, "image": "assets/images/420_cap.png", "latitude": 4.6351, "longitude": -74.0703, "description": "I Love 4:20 Cap. It's a fun cap, but I don't wear it often.", "category": "Cap"},
    {"title": "Grey Sporty Cap", "price": 130000, "image": "assets/images/grey_sporty_cap.png", "latitude": 4.6370, "longitude": -74.0824, "description": "Grey Sporty Cap. I bought it for outdoor activities, but I prefer other styles now.", "category": "Cap"}
];

  List<Map<String, dynamic>> recentlyViewedItems = [];
  Position? userPosition;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  void _storeProductView(Map<String, dynamic> product) async {
    CollectionReference views = FirebaseFirestore.instance.collection('product_views');
    
    await views.add({
      'title': product['title'],
      'category': product['category'],
      'price': product['price'],
      'viewed_at': DateTime.now(),
    });

    // Enviar evento a Firebase Analytics
    await analytics.logEvent(
      name: 'view_product',
      parameters: {
        'title': product['title'],
        'category': product['category'],
      },
    );
  }
  
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
                _storeProductView(item); 
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

  void _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    print('Tratando de obtener ubicación.');
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return; // No se puede obtener la ubicación
    }

    print(serviceEnabled);
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return; // Permiso denegado
      }
    }
    print(permission);

    userPosition = await Geolocator.getCurrentPosition();
    print(userPosition);
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Radio de la tierra en kilómetros
    double dLat = _deg2rad(lat2 - lat1);
    double dLon = _deg2rad(lon2 - lon1);
    double a = sin(dLat/2) * sin(dLat/2) + cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * sin(dLon/2) * sin(dLon/2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    double distance = R * c; // Distancia en km
    return distance;
  }

  double _deg2rad(double deg) {
    return deg * (pi/180);
  }

  List<Map<String,dynamic>> _orderByLocation(Position? userPosition, List<Map<String, dynamic>> itemsProvided) {
    if (userPosition == null) return [];
    List<String> initial_order = [];
    for (Map<String, dynamic> item in itemsProvided) {
      initial_order.add(item['title']);
    }
    // Ordenar productos según la distancia al usuario
    itemsProvided.sort((a, b) {
      double distanceA = _calculateDistance(userPosition.latitude, userPosition.longitude, a['latitude'], a['longitude']);
      double distanceB = _calculateDistance(userPosition.latitude, userPosition.longitude, b['latitude'], b['longitude']);
      return distanceA.compareTo(distanceB);
    });
    List<String> final_order = [];
    for (Map<String, dynamic> item in itemsProvided) {
      final_order.add(item['title']);
    }
    /*
    print('Se ha organizado por ubicación.');
    print(userPosition);
    print('Orden original:');
    print(initial_order);
    print('Orden final:');
    print(final_order);
    */
    return itemsProvided;

  }

  void _viewItem(BuildContext context, Map<String, dynamic> item) {
    _getUserLocation();
    List<Map<String, dynamic>> orderedItems = _orderByLocation(userPosition, original_items);
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
      // Chequea si hay al menos 3 ítems con títulos similares
      String commonWord = _findCommonWord(titleItems);
      print(titleItems);
      print(commonWord);
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
        sameItems = _orderByLocation(userPosition, sameItems);
        //print(sameItems);
        for (Map<String, dynamic> item in sameItems) {
          items.add(item);
        }
        otherItems = _orderByLocation(userPosition, otherItems);
        //print(otherItems);
        for (Map<String, dynamic> item in otherItems) {
          items.add(item);
        }
        print("Se cambió el orden de los items.");
        List<String> itemsListed = [];
        for (Map<String, dynamic> item in items) {
          itemsListed.add(item['title']);
        }
        print(itemsListed);
      }
      else {
        if (!orderedItems.isEmpty) {
          items = orderedItems;
          print("Se mantuvo el orden por ubicación geográfica.");
          List<String> itemsListed = [];
          for (Map<String, dynamic> item in items) {
            itemsListed.add(item['title']);
          }
          print(itemsListed);
        }
        else {
          items = original_items;
          print("Se recuperó o se mantuvo el orden original.");
          List<String> itemsListed = [];
          for (Map<String, dynamic> item in items) {
            itemsListed.add(item['title']);
          }
          print(itemsListed);
          }
      }
    });
    
    Navigator.pushNamed(context, '/detail', arguments: {
      'item': item,
      'allItems': items, // Asegúrate de pasar la lista 'items' como 'allItems'
    });

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
