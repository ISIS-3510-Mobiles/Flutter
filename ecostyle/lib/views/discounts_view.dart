import 'package:flutter/material.dart';

class DiscountsView extends StatelessWidget {
  DiscountsView({super.key});

  final List<List<Map<String, dynamic>>> firstPromotionBundles = [
    [
      {"title": "Sporty Jacket", "price": 120000, "image": "assets/images/sporty_jacket.png"},
      {"title": "Yellow Beauty Jacket", "price": 150000, "image": "assets/images/yellow_beauty_jacket.png"},
    ],
    [
      {"title": "Uniandes Hoodie", "price": 80000, "image": "assets/images/uniandes_sweater.png"},
      {"title": "Simple Uniandes Jacket", "price": 130000, "image": "assets/images/uniandes_jacket.png"},
    ],
    [
      {"title": "Uniandes Red Cap", "price": 50000, "image": "assets/images/uniandes_cap.png"},
      {"title": "Grey Sporty Cap", "price": 60000, "image": "assets/images/grey_sporty_cap.png"},
    ],
  ];

  final List<List<Map<String, dynamic>>> secondPromotionBundles = [
    [
      {"title": "Sporty Jacket", "price": 120000, "image": "assets/images/sporty_jacket.png"},
      {"title": "Sporty Jacket", "price": 120000, "image": "assets/images/sporty_jacket.png"},
    ],
    [
      {"title": "Uniandes Hoodie", "price": 80000, "image": "assets/images/uniandes_sweater.png"},
      {"title": "Uniandes Hoodie", "price": 80000, "image": "assets/images/uniandes_sweater.png"},
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Elimina el botón de retroceso
        backgroundColor: const Color(0xFF012826),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search in EcoStyle',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
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
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/cart'); // Navegar al carrito
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Being green pays',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              _buildHorizontalScrollBundles(firstPromotionBundles, "250000"),

              const SizedBox(height: 20),

              const Text(
                'Go now! 2x1',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              _buildHorizontalScrollBundles(secondPromotionBundles, "200000"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalScrollBundles(List<List<Map<String, dynamic>>> bundles, String bundlePrice) {
    return SizedBox(
      height: 200, // Altura total de cada sección de promoción
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: bundles.length,
        itemBuilder: (context, index) {
          final bundle = bundles[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: bundle.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Image.asset(
                              item['image'],
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              item['title'],
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\$ ${item['price']}',
                              style: const TextStyle(
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Bundle Price: \$ $bundlePrice',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
