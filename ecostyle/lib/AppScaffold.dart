import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        backgroundColor: const Color(0xFF012826), // Green background
        appBar: AppBar(
          backgroundColor: const Color(0xFF012826), // Green AppBar
          title: const Text(
            'EcoStyle',
            style: TextStyle(color: Colors.white), // White text
          ),
          iconTheme: const IconThemeData(color: Colors.white), // White menu icon
        ),
        drawer: showDrawer
            ? Drawer(
                child: Container(
                  color: const Color(0xFF012826), // Green background for drawer
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      const DrawerHeader(
                        decoration: BoxDecoration(
                          color: Color(0xFF012826), // Green header
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
                        leading: const Icon(Icons.person, color: Colors.white),
                        title: const Text(
                          'Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.receipt , color: Colors.white),
                        title: const Text(
                          'Orders',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/orders');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.list, color: Colors.white),
                        title: const Text(
                          'List Items',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/list');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.shopping_cart, color: Colors.white),
                        title: const Text(
                          'Cart',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/cart');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.eco, color: Colors.white),
                        title: const Text(
                          'Sustainability',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/sustainability');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.add, color: Colors.white),
                        title: const Text(
                          'Add Item',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/addItem');
                        },
                      ),
                      const Divider(color: Colors.white), // White divider
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.white),
                        title: const Text(
                          'Log Out',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () async {
                          final shouldLogout = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: const Color(0xFF012826), // Green background
                              title: const Text(
                                'Confirm Logout',
                                style: TextStyle(color: Colors.white),
                              ),
                              content: const Text(
                                'Are you sure you want to log out?',
                                style: TextStyle(color: Colors.white),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true), // Log out
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false), // Cancel
                                  child: const Text(
                                    'No',
                                    style: TextStyle(color: Colors.white),
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
                ),
              )
            : null,
        body: child,
      ),
    );
  }
}
