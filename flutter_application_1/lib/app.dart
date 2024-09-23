import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/shop/screens/cart/cart.dart';
import 'package:flutter_application_1/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: HomeScreen(),
    );
  }

}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  CartScreen()),
                );
              },
              child: Text('Go to First View'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondView()),
                );
              },
              child: Text('Go to Second View'),
            ),
          ],
        ),
      ),
    );
  }
}

class FirstView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First View'),
      ),
      body: Center(
        child: Text('This is the First View'),
      ),
    );
  }
}

class SecondView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second View'),
      ),
      body: Center(
        child: Text('This is the Second View'),
      ),
    );
  }
}