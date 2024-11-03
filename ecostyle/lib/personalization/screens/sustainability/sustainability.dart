import 'package:ecostyle/firebase_service.dart';
import 'package:ecostyle/models/sustainability_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Sustainability extends StatelessWidget {
  const Sustainability({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sustainability Impact'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<List<SustainabilityImpactModel>>(
          future: FirebaseService().fetchAllImpactItems(), // Fetch all items from the impact collection
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No impactful items found.'));
            }

            final impactfulItems = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Recycle Icon Placeholder
                Container(
                  child: Icon(
                    Icons.recycling,
                    size: 100,
                    color: Colors.yellow,
                  ),
                ),
                SizedBox(height: 20),

                // Display impactful items
                Text(
                  'Items with Environmental Impact:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: impactfulItems.length,
                    itemBuilder: (context, index) {
                      final item = impactfulItems[index];
                      return ListTile(
                        title: Text('Product ID: ${item.productId}'),
                        subtitle: Text(
                          'Carbon Footprint: ${item.carbonFootprint}\n'
                              'Water Usage: ${item.waterUsage}\n'
                              'Waste Diverted: ${item.wasteDiverted}',
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Learn more about your impact
                GestureDetector(
                  onTap: () {
                    _launchURL('https://www.youtube.com/watch?v=F6R_WTDdx7I');
                  },
                  child: Text(
                    'Learn more about your impact',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    // Launch URL using url_launcher package
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
