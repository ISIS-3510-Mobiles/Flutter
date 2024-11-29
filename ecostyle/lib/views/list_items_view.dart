import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // Usar esta librería para funciones de listas
import 'package:geolocator/geolocator.dart'; // Para obtener la ubicación del usuario
import 'package:cloud_firestore/cloud_firestore.dart'; // Para Firestore
import 'dart:async'; // Importa la librería Timer para Eventual Connectivity
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:isolate'; // Usa Isolate para multi-threading
import 'dart:math'; // Para calcular la distancia entre dos puntos

class ListItemsView extends StatefulWidget {
  @override
  _ListItemsViewState createState() => _ListItemsViewState();
}

class _ListItemsViewState extends State<ListItemsView> {
  List<Map<String, dynamic>> original_items = [];
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> recentlyViewedItems = [];
  Position? userPosition;
  bool isLoading = true;
  bool isOffline = false; // Estado de conexión
  //Timer? connectionTimer;
  //bool loaded = false;
  Map<String,dynamic> itemRecommended = {"title": "Sporty Jacket", "price": 120000, "image": "https://firebasestorage.googleapis.com/v0/b/kotlin-firebase-503a6.appspot.com/o/images%2Fsporty_jacket.png?alt=media&token=3c413908-747d-4f9b-8598-c35f2f40cbe7", "latitude": 4.6351, "longitude": -74.0703, "description": "Sporty Jacket size L. I bought it for a trip but never ended up using it.", "category": "Jacket", "carbonFootprint":2.25, "wasteDiverted":1.5,"waterUsage":3000, 'sustainabilityPercentage':75};

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _startConnectivityMonitoring();
    _loadItemsFromFirebase();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    //connectionTimer?.cancel();
    super.dispose();
  }

  /// Escucha cambios en la conectividad
  void _startConnectivityMonitoring() {
    _connectivitySubscription = 
        Connectivity().onConnectivityChanged.listen((connectivityResult) {
      setState(() {
        isOffline = connectivityResult == ConnectivityResult.none;
      });

      if (!isOffline) {
        // Si la conexión se restaura, intenta cargar los datos
        _loadItemsFromFirebase();
      }
    });
  }

  /** 
   Método que inicializa el chequeo de conectividad eventual
  void _startConnectivityCheck() {
    connectionTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        if (!loaded) {
          _loadItemsFromFirebase(); // Intenta recargar los datos si se restablece la conexión
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Internet connection restored. Loading products...',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    });
  }

    /** 
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No hay conexión a internet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No internet connection. Products will load once the connection is restored.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return; // Sale de la función si no hay conexión
    }*////
  *////

  Future<void> _loadItemsFromFirebase() async {
    if (isOffline) return; // No intenta cargar si no hay conexión

    

    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('items').get();
      List<Map<String, dynamic>> loadedItems = querySnapshot.docs.map((doc) {
        return {
          "title": doc['title'],
          "price": doc['price'],
          "image": doc['image'],
          "latitude": doc['latitude'],
          "longitude": doc['longitude'],
          "description": doc['description'],
          "category": doc['category'],
          "carbonFootprint": doc['carbonFootprint'],
          "wasteDiverted": doc['wasteDiverted'],
          "waterUsage": doc['waterUsage'],
          "sustainabilityPercentage": doc['sustainabilityPercentage'],
          /**
          "title": doc['name'],
          "price": doc['price'],
          "image": doc['imageResource'],
          "latitude": doc['latitude'],
          "longitude": doc['longitude'],
          "description": doc['description'],
          */
        };
      }).toList();
      //loaded = true;
      setState(() {
        original_items = loadedItems;
        items = List.from(original_items);
        isLoading = false;
      });
    } catch (e) {
      print('Error loading items from Firebase: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  //Método de Multi-threading con Isolate
  Future<void> _calculateSustainabilityPercentage() async {
  // List of items to process
  List<Map<String, dynamic>> dataToProcess = items;
  List<String> titleItems = [];

  // Collect titles from recently viewed items
  for (Map<String, dynamic> item in recentlyViewedItems) {
    titleItems.add(item['title']);
  }

  // Find the common word
  String commonWord = _findCommonWord(titleItems);

  // Use await to handle the Future returned by the isolate
  itemRecommended = await _calculateSustainabilityInIsolate(dataToProcess, commonWord);
}

static Future<Map<String, dynamic>> _calculateSustainabilityInIsolate(List<Map<String, dynamic>> products, String commonWord) async {
  double biggestValue = 0;
  double sumOfAll = 0;
  Map<String, dynamic> itemToRecommend = {
    "title": "Sporty Jacket",
    "price": 120000,
    "image": "https://firebasestorage.googleapis.com/v0/b/kotlin-firebase-503a6.appspot.com/o/images%2Fsporty_jacket.png?alt=media&token=0d7aed20-b56c-4efd-9919-0630fd6027fb",
    "latitude": 4.6351,
    "longitude": -74.0703,
    "description": "Sporty Jacket size L. I bought it for a trip but never ended up using it.",
    "category": "Jacket",
    "carbonFootprint": 2.25,
    "wasteDiverted": 1.5,
    "waterUsage": 3000,
    'sustainabilityPercentage': 10
  };

  // Perform calculations in an isolate
  itemToRecommend = await Isolate.run(() {
    if (commonWord.isNotEmpty) {
      // Filter products based on the common word
      List<Map<String, dynamic>> sameItems = [];
      for (var item in products) {
        String itemTitle = item['title'].toLowerCase();
        if (itemTitle.contains(commonWord)) {
          sameItems.add(item);
        }
      }
      products = sameItems;
    }

    // Calculate the sum of all product values
    for (var product in products) {
      double carbonFootprint = (product['carbonFootprint'] ?? 0).toDouble();
      double wasteDiverted = (product['wasteDiverted'] ?? 0).toDouble();
      double waterUsage = (product['waterUsage'] ?? 0).toDouble();

      double productValue = (carbonFootprint * 100) + (wasteDiverted * 20) + waterUsage;
      sumOfAll += productValue;
    }
    // Find the product with the highest sustainability value
    for (var product in products) {
      double carbonFootprint = (product['carbonFootprint'] ?? 0).toDouble();
      double wasteDiverted = (product['wasteDiverted'] ?? 0).toDouble();
      double waterUsage = (product['waterUsage'] ?? 0).toDouble();

      double productValue = (carbonFootprint * 100) + (wasteDiverted * 20) + waterUsage;
      if (productValue / sumOfAll > biggestValue) {
        biggestValue = productValue;
        itemToRecommend = product;
      }
    }

    // Calculate the sustainability percentage
    double percentage = (biggestValue / sumOfAll) * 100;
    itemToRecommend['sustainabilityPercentage'] = percentage.ceil();

    return itemToRecommend;
  });

  return itemToRecommend;
}


  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (isOffline) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF012826),
          title: Text('EcoStyle'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 80, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'No internet connection. Please check your network.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      );
    }

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
                        child: Image.network(
                          item['image'],
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.2,
                          errorBuilder: (context, error, stackTrace) {
                            // Icono de "imagen no disponible"
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'No image available',
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          },
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF012826),
        child: Icon(Icons.recycling, size: 30, color: Colors.white,), // Icono de reciclaje
        onPressed: () {
          _calculateSustainabilityPercentage();
          Navigator.pushNamed(context, '/recommendation', arguments: {
            'item': itemRecommended,
          }); 

          
        },
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