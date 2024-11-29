import 'package:ecostyle/firebase_service.dart';
import 'package:ecostyle/models/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isConnected = true; // Connectivity flag
  String _title = '';
  int _price = 0;
  String? _imagePath; // Nullable image path
  final double _latitude = 4.6351;
  final double _longitude = -74.0703;
  String _description = '';
  String _category = '';
  bool _enviromentalImpact = false;
  double _carbonFootprint = 2.56;
  double _sustainabilityPercentage = 80;
  double _wasteDiverted = 3.4;
  double _waterUsage = 3500;

  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
    if (!_isConnected) {
      _showNoConnectionDialog();
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path; // Update the local path
      });

      try {
        // Upload to Firebase Storage
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final ref = FirebaseStorage.instance
            .ref()
            .child('products/images/$fileName');

        await ref.putFile(File(image.path));

        // Get the download URL
        String downloadUrl = await ref.getDownloadURL();

        setState(() {
          _imagePath = downloadUrl; // Use the URL for views
        });

        print('Image uploaded successfully: $downloadUrl');
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image')),
        );
      }
    } else {
      // If no image was picked, keep the default image
      setState(() {
        _imagePath = 'https://firebasestorage.googleapis.com/v0/b/kotlin-firebase-503a6.appspot.com/o/products%2Fimages%2Fpexels-cottonbro-4068314.jpg?alt=media'; // URL of your default image in Firebase Storage
      });
    }
  }

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please check your internet connection and try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView( // Allow scrolling when the keyboard is open
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title field
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              // Price field
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _price = int.tryParse(value) ?? 0;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),

              // Image selection
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    image: _imagePath != null
                        ? DecorationImage(
                      image: FileImage(File(_imagePath!)),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: _imagePath == null
                      ? Center(child: Text('Tap to select image'))
                      : null,
                ),
              ),
              SizedBox(height: 16),

              // Description field
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              // Category field
              TextFormField(
                decoration: InputDecoration(labelText: 'Category'),
                onChanged: (value) {
                  setState(() {
                    _category = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),

              // Submit button
              ElevatedButton(
                onPressed: () async {
                  await _checkConnectivity(); // Update connectivity status
                  if (_isConnected) {
                    if (_formKey.currentState!.validate()) {
                      final newProduct = ProductModel(
                        id: DateTime.now().toString(),
                        title: _title,
                        price: _price,
                        image: _imagePath ?? '',
                        latitude: _latitude,
                        longitude: _longitude,
                        description: _description,
                        category: _category,
                        environmentalImpact: _enviromentalImpact,
                        carbonFootprint: _carbonFootprint,
                        sustainabilityPercentage: _sustainabilityPercentage,
                        wasteDiverted: _wasteDiverted,
                        waterUsage: _waterUsage,
                      );
                      await firebaseService.addProduct(newProduct);
                      Navigator.pop(context);
                    }
                  } else {
                    // Show dialog if offline
                    _showNoConnectionDialog();
                  }
                },
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}