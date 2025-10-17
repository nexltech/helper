import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  const SplashScreen({super.key, required this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => widget.nextScreen),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            Center(
              child: Text(
                'H',
                style: TextStyle(
                  fontFamily: 'FrederickaTheGreat',
                  fontSize: 90,
                  color: Colors.black,
                ),
              ),
            ),
            const Spacer(flex: 2),
            Text(
              'Helpr',
              style: const TextStyle(
                fontFamily: 'HomemadeApple',
                fontSize: 32,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Text(
            //   'Find Work. Hire Local. Build Community.',
            //   style: const TextStyle(
            //     fontFamily: 'LifeSavers',
            //     fontSize: 18,
            //     color: Color(0xFFB0C4DE),
            //     fontWeight: FontWeight.w400,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
