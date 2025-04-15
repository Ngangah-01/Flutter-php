import 'package:flutter/material.dart';
import 'login_page.dart';

class LoaderScreen extends StatefulWidget {
  const LoaderScreen({super.key});

  @override
  _LoaderScreenState createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // Makes the dots bounce

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Rotating Animation
            RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
              child: const SizedBox(
                width: 50,
                height: 50,
              ),
            ),

            // Bouncing Dots
            Positioned(
              top: 0,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _controller.value,
                    child: _dot(),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1 - _controller.value,
                    child: _dot(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot() {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}
