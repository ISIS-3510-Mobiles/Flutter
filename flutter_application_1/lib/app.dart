import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/authentication/views/detail_view.dart';
import 'package:flutter_application_1/features/authentication/views/list_items_view.dart';
import 'package:flutter_application_1/features/authentication/views/login_view.dart';
import 'package:flutter_application_1/features/authentication/views/profile_view.dart';
import 'package:flutter_application_1/features/authentication/views/register_view.dart';
import 'package:flutter_application_1/features/personalization/screens/sustainability/sustainability.dart';
import 'package:flutter_application_1/features/shop/screens/cart/cart.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoStyle',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login', // Inicia en la vista de login
      routes: {
        '/login': (context) => LoginView(),
        '/register': (context) => RegisterView(),
        '/profile': (context) => ProfileView(),
        '/detail': (context) => DetailView(),
        '/list': (context) => ListItemsView(),
        '/sustainability' : (context) => Sustainability(),
        '/cart': (context) => CartScreen()
      },
    );
  }

}


