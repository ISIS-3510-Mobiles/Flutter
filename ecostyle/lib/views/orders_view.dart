import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OrdersView extends StatefulWidget {
  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;
  bool isConnected = true;

  int firebaseLoadCounter = 0;
  int cacheLoadCounter = 0;

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _loadOrders();
  }

  Future<void> _checkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isConnected = false;
      });
    } else {
      setState(() {
        isConnected = true;
      });
      // If connected, attempt to reload the data from Firebase
      _loadOrders();
    }
    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          isConnected = false;
        });
      } else {
        setState(() {
          isConnected = true;
        });
        _loadOrders();
      }
    });
  }

  Future<void> _loadOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedOrders = prefs.getString('cachedOrders');

    if (cachedOrders != null) {
      // Increment cache load counter
      cacheLoadCounter++;

      // Load cached data
      List<Map<String, dynamic>> cachedList = List<Map<String, dynamic>>.from(
        json.decode(cachedOrders).map((item) => Map<String, dynamic>.from(item)),
      );

      // Convert orderDate strings back to DateTime objects
      cachedList = cachedList.map((order) {
        if (order['orderDate'] != null) {
          order['orderDate'] = DateTime.parse(order['orderDate']);
        }
        return order;
      }).toList();

      setState(() {
        orders = cachedList;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }

    try {
      if (isConnected) {
        // Increment Firebase load counter
        firebaseLoadCounter++;

        // Fetch data from Firebase
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('orders').get();

        List<Map<String, dynamic>> loadedOrders = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            "orderDate": data['orderDate'] != null
                ? (data['orderDate'] as Timestamp).toDate().toIso8601String()
                : null,
            "status": data['status'] ?? 'Confirmed',
            "totalAmount": data['totalAmount'],
            "userId": data['userId'],
            "items": data['items'] ?? [],
            "paymentMethod": data['paymentMethod'] ?? 'Not specified',
          };
        }).toList();

        // Cache data locally
        await prefs.setString('cachedOrders', json.encode(loadedOrders));

        setState(() {
          orders = loadedOrders;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading orders from Firebase: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF012826),
        title: const Text(
          'My Orders',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/list');
          },
        ),
      ),
      body: Column(
        children: [
          if (!isConnected)
            Container(
              color: Colors.red,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'No internet connection. Displaying cached data if available.',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: orders.isEmpty
                  ? const Center(child: Text('No orders found.'))
                  : ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to the OrderDetailView and pass the order as an argument
                            Navigator.pushNamed(
                              context,
                              '/orderDetail',
                              arguments: order,
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Order Date: ${order['orderDate'] ?? 'N/A'}'),
                                  Text('Total Amount: \$${order['totalAmount']}'),
                                  Text('Status: ${order['status']}'),
                                  Text('Payment Method: ${order['paymentMethod']}'),
                                  const SizedBox(height: 10),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(
                                        order['items'].length,
                                        (itemIndex) {
                                          final item = order['items'][itemIndex];
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: Column(
                                              children: [
                                                Image.network(
                                                  item['image'] ?? '',
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                                const SizedBox(height: 5),
                                                SizedBox(
                                                  width: 80,
                                                  child: Text(
                                                    item['title'] ?? 'No title',
                                                    style: const TextStyle(fontSize: 12),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                Text(
                                                  '\$${item['price']}',
                                                  style: const TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
