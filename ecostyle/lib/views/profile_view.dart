import 'dart:io'; // Import the File class
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart'; 
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'change_password_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String? _profileImageUrl;
  bool _isUploading = false; // Track upload status

  Future<Map<String, String>> _fetchUserData() async {
    User? user = _auth.currentUser; // Obtain the authenticated user
    Map<String, String> userData = {
      'name': '',
      'phone': '',
      'address': '',
    };

    if (user != null) {
      // Find the document corresponding to the user in Firestore
      DocumentSnapshot userDoc = await _firestore.collection('User').doc(user.email).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>; // Cast data to the correct type

        userData['name'] = data['name'] ?? ''; // Ensure Firestore fields match
        userData['phone'] = data['phone'] ?? '';
        userData['address'] = data['address'] ?? '';

        // Load the profile image URL, if it exists
        _profileImageUrl = data.containsKey('imgUrl') ? data['imgUrl'] : null; // Check if imgUrl exists
      }
    }

    return userData; // Return user data
  }

  Future<void> _changeProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    
    // Show an option to choose between camera and gallery
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          backgroundColor: const Color(0xFFECECEC), // Light gray background for dialog
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF007451), // Lime green text
              ),
              child: const Text('Camera'),
              onPressed: () {
                Navigator.of(context).pop(ImageSource.camera);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF007451), // Lime green text
              ),
              child: const Text('Gallery'),
              onPressed: () {
                Navigator.of(context).pop(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );

    if (source != null) {
      final XFile? image = await _picker.pickImage(source: source);

      if (image != null) {
        // Show uploading message
        setState(() {
          _isUploading = true;
        });

        // If the user selects an image, upload it to Firebase Storage
        String fileName = '${_auth.currentUser!.email}.jpg'; // Use the email as the file name
        Reference storageRef = _storage.ref().child('profile_images/$fileName');

        try {
          await storageRef.putFile(File(image.path)); // Use File here
          String downloadUrl = await storageRef.getDownloadURL();

          // Update the image URL in Firestore
          await _firestore.collection('User').doc(_auth.currentUser!.email).update({'imgUrl': downloadUrl});
          
          // Update the local profile image URL state
          setState(() {
            _profileImageUrl = downloadUrl; // Update state to show the new image
            _isUploading = false; // Stop uploading status
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image updated correctly!')),
          );
        } catch (e) {
          // Handle errors, e.g., show a snackbar
          setState(() {
            _isUploading = false; // Stop uploading status on error
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('There was an error updating your image, please try later.')),
          );
        }
      }
    }
  }

  Future<void> authenticate(BuildContext context) async {
    final LocalAuthentication localAuth = LocalAuthentication();
    bool authenticated = false;

    try {
      authenticated = await localAuth.authenticate(
        localizedReason: 'Please authenticate to change your password',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (e) {
      // Handle the error, like showing a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication failed')),
      );
    }

    if (authenticated) {
      // If authentication is successful, navigate to ChangePasswordView
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChangePasswordView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: Center(
        child: FutureBuilder<Map<String, String>>(
          future: _fetchUserData(), // Call the function to fetch data
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show a loading indicator
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final userData = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center, // Center the elements
                  children: [
                    const SizedBox(height: 24), 
                    const Text(
                      'Profile', // Changed to English
                      style: TextStyle(
                        fontSize: 38.4, 
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF012826), // Dark green to highlight
                      ),
                    ),
                    const SizedBox(height: 24), 
                    GestureDetector(
                      onTap: _changeProfileImage, // Change image on tap
                      child: CircleAvatar(
                        radius: 72, 
                        backgroundImage: _profileImageUrl != null 
                          ? NetworkImage(_profileImageUrl!) 
                          : const AssetImage('assets/images/profile_image.png') as ImageProvider, // Use the network image or asset
                      ),
                    ),
                    
                    // "Change Picture" button
ElevatedButton(
  onPressed: _changeProfileImage,
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.white), // White background
    foregroundColor: MaterialStateProperty.all(const Color(0xFF007451)), // Lime green text
    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0)), // Smaller button
    elevation: MaterialStateProperty.all(0), // Remove elevation
  ),
  child: const Text(
    'Change Picture',
    style: TextStyle(fontSize: 16.0), // Smaller font size
  ),
),

                    const SizedBox(height: 19.2), 
                    Text(
                      userData['name']!.isEmpty ? 'Loading...' : userData['name']!, // Show loading text
                      style: const TextStyle(
                        fontSize: 28.8, 
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 9.6), 
                    Text(
                      userData['phone']!.isEmpty ? 'Loading...' : userData['phone']!, // Show loading text
                      style: TextStyle(
                        fontSize: 21.6,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 9.6),
                    Text(
                      userData['address']!.isEmpty ? 'Loading...' : userData['address']!, // Show loading text
                      style: TextStyle(
                        fontSize: 21.6,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 36), 

                    // Button to update info
                    ElevatedButton(
                      onPressed: () async {
                        // Navigate to the update info view and await its result
                        await Navigator.pushNamed(context, '/update');
                        // Reload the profile data upon return
                        setState(() {});
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color(0xFF007451)), // Lime green color
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 14.4, horizontal: 48), 
                        ), // Button spacing
                      ),
                      child: const Text(
                        'Update Info',
                        style: TextStyle(
                          fontSize: 21.6, // Font size for the button
                          color: Colors.white, // White text color
                        ),
                      ),
                    ),
                    const SizedBox(height: 9.6), 
                    ElevatedButton(
                      onPressed: () => authenticate(context), // Call the authenticate function
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color(0xFF007451)), // Lime green color
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 14.4, horizontal: 48), 
                        ), // Button spacing
                      ),
                      child: const Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 21.6, // Font size for the button
                          color: Colors.white, // White text color
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No user data available')); // Message for no data
            }
          },
        ),
      ),
    );
  }
}
