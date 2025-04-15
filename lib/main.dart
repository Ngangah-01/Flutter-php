import 'package:flutter/material.dart';
import 'screens/home_page.dart'; // Import HomePage
// import 'screens/login_page.dart'; // Import LoginPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Voting App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/home", // Set the first screen to LoginPage
      routes: {
        "/login": (context) => const LandingPage(),
        "/home": (context) => const LandingPage(),
      },
    );
  }
}
