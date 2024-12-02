import 'package:ecostyle/AppScaffold.dart';
import 'package:ecostyle/personalization/screens/events/events.dart';
import 'package:ecostyle/shop/controlers/ProductModelAdapter.dart';
import 'package:ecostyle/shop/screens/addItem/addItem.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'firebase_service.dart'; 
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/profile_view.dart';
import 'views/list_items_view.dart';
import 'views/detail_view.dart';
import 'views/sustainable_recommendation.dart';
import 'views/update_info_view.dart';
import 'views/orders_view.dart';
import 'views/order_detail_view.dart';
import 'package:ecostyle/shop/screens/cart/cart.dart';
import 'package:ecostyle/personalization/screens/sustainability/sustainability.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Hive.initFlutter();

    Hive.registerAdapter(ProductModelAdapter());
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
          '/update': (context) => AppScaffold(child: const UpdateInfoView(), routeName: '/update'),
          '/detail': (context) => AppScaffold(child: DetailView(), routeName: '/detail'),
          '/list': (context) => AppScaffold(child: ListItemsView(), routeName: '/list'),
          '/cart': (context) => AppScaffold(child: const CartScreen(), routeName: '/cart'),
          '/sustainability': (context) => AppScaffold(child: const Sustainability(), routeName: '/sustainability'),
          '/recommendation': (context) => AppScaffold(child: const SustainableRecommendationView(), routeName: '/recommendation'),
          '/addItem': (context) => AppScaffold(child:  AddProductScreen(), routeName: '/addItem'),
          '/events': (context) => AppScaffold(child:  EventsScreen(), routeName: '/events'),
          '/orders': (context) => AppScaffold(child:  OrdersView(), routeName: '/orders'),
          '/orderDetail': (context) {final order = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return AppScaffold(child: OrderDetailView(order: order), routeName: '/orderDetail');
          }
        },
      ),
    );
  }
}
