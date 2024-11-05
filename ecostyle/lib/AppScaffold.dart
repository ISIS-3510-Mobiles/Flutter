import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final String? routeName;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage(); // Initialize secure storage

  AppScaffold({
    Key? key,
    required this.child,
    this.routeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if the route is login or signup to conditionally show the Drawer
    bool showDrawer = routeName != '/login' && routeName != '/register';

    return WillPopScope(
      onWillPop: () async {
        // If the drawer is open, close it instead of going back
        if (showDrawer && Scaffold.of(context).isDrawerOpen) {
          Navigator.of(context).pop(); // Close the drawer
          return false; // Prevent the default back navigation
        }
        return true; // Allow normal back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF012826), // Updated green color
          title: const Text(
            'EcoStyle',
            style: TextStyle(color: Colors.white), // White text
          ),
        ),
        drawer: showDrawer
            ? Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Color(0xFF012826),
                      ),
                      child: Text(
                        'EcoStyle Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),

                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Profile'),
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.list),
                      title: const Text('List Items'),
                      onTap: () {
                        Navigator.pushNamed(context, '/list');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.shopping_cart),
                      title: const Text('Cart'),
                      onTap: () {
                        Navigator.pushNamed(context, '/cart');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.eco),
                      title: const Text('Sustainability'),
                      onTap: () {
                        Navigator.pushNamed(context, '/sustainability');
                      },
                    ),
                    const Divider(), // Add a divider for better visual separation
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Log Out'),
                      onTap: () async {
                        final shouldLogout = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Logout'),
                            content: const Text('Are you sure you want to log out?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true), // Log out
                                child: Text(
                                  'Yes',
                                  style: TextStyle(color: const Color(0xFF012826)), // Set text color to green
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false), // Cancel
                                child: Text(
                                  'No',
                                  style: TextStyle(color: const Color(0xFF012826)), // Set text color to green
                                ),
                              ),
                            ],
                          ),
                        );

                        if (shouldLogout == true) {
                          // Sign out of Firebase
                          await FirebaseAuth.instance.signOut();

                          // Instead of clearing all cache, just navigate to login
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (Route<dynamic> route) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),
              )
            : null,
        body: child,
      ),
    );
  }
}
