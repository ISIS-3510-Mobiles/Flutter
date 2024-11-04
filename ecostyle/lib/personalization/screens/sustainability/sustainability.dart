import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecostyle/firebase_service.dart';
import 'package:ecostyle/models/sustainability_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Sustainability extends StatefulWidget {
  const Sustainability({super.key});

  @override
  _SustainabilityState createState() => _SustainabilityState();
}

class _SustainabilityState extends State<Sustainability> {
  // Define maximums for progress bars (adjust as needed)
  static const double maxCarbonFootprint = 1000.0;
  static const double maxWaterUsage = 5000.0;
  static const double maxWasteDiverted = 100.0;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showNoConnectionDialog();
    }
  }

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Internet Connection'),
        content: const Text('Please check your internet connection and try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: const Color(0xFF012826),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<List<SustainabilityImpactModel>>(
          future: FirebaseService().fetchAllImpactItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No impactful items found.'));
            }

            final impactfulItems = snapshot.data!;
            final totals = _calculateTotals(impactfulItems);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.recycling, size: 100, color: Color(0xFF012826)),
                const SizedBox(height: 20),
                const Text(
                  'Total Environmental Impact:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Progress Bars for each metric
                _buildProgressBar('Carbon Footprint', totals['carbonFootprint']!, maxCarbonFootprint),
                _buildProgressBar('Water Usage', totals['waterUsage']!, maxWaterUsage),
                _buildProgressBar('Waste Diverted', totals['wasteDiverted']!, maxWasteDiverted),

                const SizedBox(height: 20),
                const Text(
                  'Items with Environmental Impact:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // List of impactful items
                Expanded(
                  child: ListView.builder(
                    itemCount: impactfulItems.length,
                    itemBuilder: (context, index) {
                      final item = impactfulItems[index];
                      return ListTile(
                        title: Text('Product ID: ${item.productId}'),
                        subtitle: Text(
                          'Carbon offset: ${item.carbonFootprint} ppm\n'
                              'Water Usage: ${item.waterUsage} L\n'
                              'Waste Diverted: ${item.wasteDiverted} kg',
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Learn more link
                GestureDetector(
                  onTap: () {
                    _launchURL('https://www.youtube.com/watch?v=F6R_WTDdx7I');
                  },
                  child: const Text(
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

  // Helper method to calculate totals for each metric
  Map<String, double> _calculateTotals(List<SustainabilityImpactModel> items) {
    double totalCarbon = 0;
    double totalWater = 0;
    double totalWaste = 0;

    for (var item in items) {
      totalCarbon += item.carbonFootprint;
      totalWater += item.waterUsage;
      totalWaste += item.wasteDiverted;
    }

    return {
      'carbonFootprint': totalCarbon,
      'waterUsage': totalWater,
      'wasteDiverted': totalWaste,
    };
  }

  // Helper method to build a progress bar for a specific metric
  Widget _buildProgressBar(String label, double value, double maxValue) {
    final percentage = (value / maxValue).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(2)}'),
        SizedBox(
          height: 10,
          child: LinearProgressIndicator(
            value: percentage,
            color: Colors.green,
            backgroundColor: Colors.grey[300],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // URL launcher
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
