import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecostyle/firebase_service.dart';
import 'package:ecostyle/models/product_model.dart';

class AddImpactScreen extends StatefulWidget {
  @override
  _AddImpactScreenState createState() => _AddImpactScreenState();
}

class _AddImpactScreenState extends State<AddImpactScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedItem; // Selected item from dropdown
  String _selectedBrand = 'Fast Fashion'; // Default brand
  String _selectedMaterial = ''; // Material selected by the user
  double _weight = 0.0; // Weight of the item

  // Replace with your actual list of items fetched from your data source
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];
  final List<String> _brands = ['Fast Fashion', 'Local', 'Handmade', 'Donated'];
  final List<String> _materials = ['Cotton', 'Polyester', 'Wool', 'Leather']; // Example materials

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Impact'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Dropdown for selecting an item
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Item'),
                value: _selectedItem,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedItem = newValue;
                  });
                },
                items: _items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select an item';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Dropdown for selecting a brand
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Brand'),
                value: _selectedBrand,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBrand = newValue!;
                  });
                },
                items: _brands.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),

              // Dropdown for selecting material
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Material'),
                value: _selectedMaterial.isNotEmpty ? _selectedMaterial : null,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMaterial = newValue!;
                  });
                },
                items: _materials.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a material';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Input for weight
              TextFormField(
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _weight = double.tryParse(value) ?? 0.0;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a weight';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Submit button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Prepare and send the data to your Firebase service
                    final impactData = {
                      'item': _selectedItem,
                      'brand': _selectedBrand,
                      'material': _selectedMaterial,
                      'weight': _weight,
                    };
                    await firebaseService.addImpact(impactData);
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Impact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
