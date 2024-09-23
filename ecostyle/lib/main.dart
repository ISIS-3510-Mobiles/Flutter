import 'package:flutter/material.dart';
import 'views/list_items_view.dart';
import 'views/detail_view.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/profile_view.dart';

void main() {
  runApp(EcoStyleApp());
}

class EcoStyleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoStyle',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/list', // Inicia en la vista de login
      routes: {
        '/login': (context) => LoginView(),
        '/register': (context) => RegisterView(),
        '/profile': (context) => ProfileView(),
        '/detail': (context) => DetailView(),
        '/list': (context) => ListItemsView(),
      },
    );
  }
}
