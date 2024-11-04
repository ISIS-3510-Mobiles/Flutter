import 'package:flutter/material.dart';



class Sustainability extends StatelessWidget {
  const Sustainability({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sustainability Impact'),
          backgroundColor: Colors.black,
        ),
        body: Padding(
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
              buildProgressBar('Money Raised', Colors.yellow, 0.7),
              buildProgressBar('Water Saved', Colors.blue, 0.3),
              buildProgressBar('Waste Diverted', Colors.black, 0.6),
              buildProgressBar('CO2 Emissions Prevented', Colors.yellow, 0.8),

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
        ),
      ),
    );
  }

  // Helper method to create labeled progress bars
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
