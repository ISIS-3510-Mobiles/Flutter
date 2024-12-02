import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersView extends StatefulWidget {
  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrdersFromFirebase();
  }

  Future<void> _loadOrdersFromFirebase() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('orders').get();

      List<Map<String, dynamic>> loadedOrders = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          "orderDate": data['orderDate'] != null
              ? (data['orderDate'] as Timestamp).toDate()
              : null,
          "status": data['status'] ?? 'Confirmed',
          "totalAmount": data['totalAmount'],
          "userId": data['userId'],
          "items": data['items'] ?? [],
          "paymentMethod": data['paymentMethod'] ?? 'Not specified',
        };
      }).toList();

      setState(() {
        orders = loadedOrders;
        isLoading = false;
      });
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
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
                    SizedBox(
                      height: 100, // Altura fija para evitar desbordamientos
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: order['items'].length,
                        itemBuilder: (context, itemIndex) {
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
                                Text(
                                  item['title'] ?? 'No title',
                                  style: const TextStyle(fontSize: 12),
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
