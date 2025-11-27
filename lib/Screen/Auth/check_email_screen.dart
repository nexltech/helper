import 'package:flutter/material.dart';

class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Center(
                child: Text(
                  'H',
                  style: const TextStyle(
                    fontFamily: 'FrederickaTheGreat',
                    fontSize: 90,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Check Your Email',
                style: const TextStyle(
                  fontFamily: 'HomemadeApple',
                  fontSize: 32,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'We have sent password recovery instructions to your email address.',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LifeSavers'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: Colors.black, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Ok',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'BioRhyme',
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
