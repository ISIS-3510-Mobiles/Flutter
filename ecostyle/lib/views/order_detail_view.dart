import 'package:flutter/material.dart';

class OrderDetailView extends StatelessWidget {
  final Map<String, dynamic> order;

  OrderDetailView({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF012826),
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/orders');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${order['orderId'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Date: ${order['orderDate'] != null ? order['orderDate'].toLocal() : 'Date not available'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Amount: \$${order['totalAmount'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Status: ${order['status'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: order['items'] != null && order['items'].isNotEmpty
                  ? ListView.builder(
                      itemCount: order['items'].length,
                      itemBuilder: (context, index) {
                        final item = order['items'][index];
                        return GestureDetector(
                          onTap: () {
                          Navigator.pushNamed(
                           context,
                           '/detail',
                           arguments: {
                            'item': item, // Current product item
                            'allItems': order['items'], // All items in the order
                               },
                              );
                            },

                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: item['imageUrl'] != null &&
                                            Uri.tryParse(item['imageUrl'])?.hasAbsolutePath == true
                                        ? Image.network(
                                            item['imageUrl'],
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                    value: loadingProgress.expectedTotalBytes != null
                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                            (loadingProgress.expectedTotalBytes ?? 1)
                                                        : null,
                                                  ),
                                                );
                                              }
                                            },
                                            errorBuilder: (context, error, stackTrace) {
                                              print('Image loading error: $error');
                                              return Container(
                                                width: 100,
                                                height: 100,
                                                color: Colors.grey[300],
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.error,
                                                    size: 50,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : Container(
                                            width: 100,
                                            height: 100,
                                            color: Colors.grey[300],
                                            child: const Center(
                                              child: Icon(
                                                Icons.image,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['title'] ?? 'Unnamed Item',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Price: \$${item['price'] ?? 'N/A'}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Description: ${item['description'] ?? 'No description'}',
                                          style: const TextStyle(fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No items available for this order.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
