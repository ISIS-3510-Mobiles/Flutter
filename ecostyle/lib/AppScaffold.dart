import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final String? routeName;

  const AppScaffold({
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
                        final prefs = await SharedPreferences.getInstance();

                        // Clear cached email and password
                        await prefs.remove('email');
                        await prefs.remove('password');

                        // Sign out of Firebase
                        await FirebaseAuth.instance.signOut();

                        // Navigate to the login view and clear the stack
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (Route<dynamic> route) => false,
                        );
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
