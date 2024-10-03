import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/personalization/models/sustainability_model.dart';

class Sustainability extends StatelessWidget {
  const Sustainability({super.key});

  Future<SustainabilityImpact> fetchSustainabilityData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('sustainability')
        .doc('impactData') 
        .get();

    return SustainabilityImpact.fromFirestore(snapshot.data() as Map<String, dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sustainability Impact'),
          backgroundColor: Colors.black,
        ),
        body: FutureBuilder<SustainabilityImpact>(
          future: fetchSustainabilityData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error fetching data'));
            } else {
              SustainabilityImpact? data = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
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

                    // Progress Bars with Labels
                    buildProgressBar('Money Raised', Colors.yellow, data!.moneyRaised),
                    buildProgressBar('Water Saved', Colors.blue, data.waterSaved),
                    buildProgressBar('Waste Diverted', Colors.black, data.wasteDiverted),
                    buildProgressBar('CO2 Emissions Prevented', Colors.yellow, data.co2EmissionsPrevented),

                    SizedBox(height: 30),

                    // Learn more about your impact
                    Text(
                      'Learn more about your impact',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildProgressBar(String label, Color color, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5),
        LinearProgressIndicator(
          value: value,
          minHeight: 10,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
