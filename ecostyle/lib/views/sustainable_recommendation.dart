import 'package:flutter/material.dart';

class SustainableRecommendationView extends StatefulWidget {
  const SustainableRecommendationView({super.key});

  @override
  _SustainableRecommendationState createState() => _SustainableRecommendationState();
}

class _SustainableRecommendationState extends State<SustainableRecommendationView> {

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final Map<String, dynamic> item = args['item'];

    return Scaffold(
      appBar: AppBar(
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
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                      'Sustainable Recommendation:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
            Image.network(
                    item['image'], // La URL de la imagen desde Firebase Storage
                      height: MediaQuery.of(context).size.height * 0.4,
                      fit: BoxFit.contain,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        }
                      },
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        return Icon(Icons.error, size: 50, color: Colors.red);
                      },
                    ),
            const SizedBox(height: 20),
            Text(
              item['title'],
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Text(
              '\$ ${item['price']}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Text(
              item['description'],
              style: const TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: const Icon(Icons.favorite_border),
              color: Colors.black54,
              onPressed: () {
                // Logic to add to favorites
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007451),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 80),
              ),
              onPressed: () {
                // Logic to buy now
              },
              child: const Text(
                'Buy Now',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7FB9A8),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
              ),
              onPressed: () {
                // Logic to add to cart
              },
              child: const Text(
                'Add to Cart',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sustainability Measures:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Carbon Footprint: ${item['carbonFootprint']}'),
                    Text('Waste Diverted: ${item['wasteDiverted']}'),
                    Text('Water Usage: ${item['waterUsage']}'),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/leaf_icon.png',
                      height: 40,
                    ),
                    Text('${item['sustainabilityPercentage']}%', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
 