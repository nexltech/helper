import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'create_account_screen.dart';

class LoginOrCreateScreen extends StatelessWidget {
  const LoginOrCreateScreen({super.key});

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
              const Spacer(flex: 3),
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
              const Spacer(),
              Text(
                'Welcome to Helpr',
                style: const TextStyle(
                  fontFamily: 'HomemadeApple',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Find Work. Hire Local. Build Community.',
                style: const TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 18,
                  color: Color(0xFFB0C4DE), // light blue-grey
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const CreateAccountScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: Colors.black, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: Colors.black, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
