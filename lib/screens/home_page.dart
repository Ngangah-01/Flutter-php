import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'login_page.dart'; // Import your login page

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (context) => Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: SpinKitFadingCircle(
              color: Colors.blue, // Change to match your theme
              size: 50.0,
            ),
          ),
        ),
      ),
    );

    // Simulate loading delay, then navigate
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); // Close the loading dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Ballotify",
                style: TextStyle(
                  fontSize: 45,
                  color: Color.fromARGB(255, 17, 17, 17),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Securing your choice",
                style: TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 17, 17, 17),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () => _showLoadingDialog(context),
                  child: const Text("JOIN"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
