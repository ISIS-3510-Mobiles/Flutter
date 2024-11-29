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
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('orders').get();
      List<Map<String, dynamic>> loadedOrders = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> orderData = {
          "orderId": doc['orderId'],
          "orderDate": doc['orderDate'] != null ? doc['orderDate'].toDate() : null,
          "status": doc['status'],
          "totalAmount": doc['totalAmount'],
          "userId": doc['userId'],
          "items": [],
        };

        // Fetch item details
        List<DocumentReference> itemRefs = List<DocumentReference>.from(doc['items']);
        List<Map<String, dynamic>> itemDetails = await _fetchItemDetails(itemRefs);
        orderData['items'] = itemDetails;

        loadedOrders.add(orderData);
      }

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

  Future<List<Map<String, dynamic>>> _fetchItemDetails(List<DocumentReference> itemRefs) async {
    List<Map<String, dynamic>> itemDetailsList = [];
    for (DocumentReference itemRef in itemRefs) {
      DocumentSnapshot itemSnapshot = await itemRef.get();
      if (itemSnapshot.exists) {
        itemDetailsList.add(itemSnapshot.data() as Map<String, dynamic>);
      }
    }
    return itemDetailsList;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF012826),
        title: Text(
          'My Orders',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
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
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text('Order ID: ${order['orderId']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: ${order['orderDate'] != null ? order['orderDate']!.toLocal() : 'Date not available'}',
                    ),
                    Text('Total: \$${order['totalAmount']}'),
                    Text('Status: ${order['status']}'),
                    Text(
                      'Items: ${order['items'].map((item) => item['title'] ?? 'Unnamed').join(', ')}',
                    ),
                    SizedBox(
                      height: 100, // Adjust the height as needed
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: order['items'].length,
                        itemBuilder: (context, itemIndex) {
                          final item = order['items'][itemIndex];
                          return item['imageUrl'] != null
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Image.network(
                                    item['imageUrl'],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300], // Placeholder for missing image
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                  ],
                ),
                isThreeLine: true,
                onTap: () {
                  // Navigate to detailed order view with the order data passed as arguments
                  Navigator.pushNamed(
                    context,
                    '/orderDetail',
                    arguments: order,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
