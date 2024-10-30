import 'package:ecostyle/AppScaffold.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'firebase_service.dart'; 
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/profile_view.dart';
import 'views/list_items_view.dart';
import 'views/detail_view.dart';
import 'package:ecostyle/shop/screens/cart/cart.dart';
import 'package:ecostyle/personalization/screens/sustainability/sustainability.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => FirebaseService()), // Provide the Firebase service
      ],
      child: MaterialApp(
        title: 'EcoStyle',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginView(),
          '/register': (context) => const RegisterView(),
          '/profile': (context) => AppScaffold(child: const ProfileView(), routeName: '/profile'),
          '/detail': (context) => AppScaffold(child: DetailView(), routeName: '/detail'),
          '/list': (context) => AppScaffold(child: ListItemsView(), routeName: '/list'),
          '/cart': (context) => AppScaffold(child: const CartScreen(), routeName: '/cart'),
          '/sustainability': (context) => AppScaffold(child: const Sustainability(), routeName: '/sustainability'),
        },
      ),
    );
  }
}
