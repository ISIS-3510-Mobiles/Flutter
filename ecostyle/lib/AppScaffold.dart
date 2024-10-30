import 'package:flutter/material.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoStyle'),
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
                    onTap: () {
                      // Navigate to the login view
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
    );
  }
}
