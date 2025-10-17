import 'package:flutter/material.dart';
import '../../../Screen/profile/client_profile_screen.dart';
import '../../../Screen/profile/worker_profile_screen.dart';
import '../../../Screen/profile/both_profile_screen.dart';

class ChooseRoleScreen extends StatefulWidget {
  const ChooseRoleScreen({super.key});

  @override
  State<ChooseRoleScreen> createState() => _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends State<ChooseRoleScreen> {
  int? _selectedRole;

  void _goToProfile() {
    if (_selectedRole == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ClientProfileScreen()),
      );
    } else if (_selectedRole == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const WorkerProfileScreen()),
      );
    } else if (_selectedRole == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const BothProfileScreen()),
      );
    }
  }

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
              const SizedBox(height: 24),
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
              const SizedBox(height: 16),
              Text(
                'How will you use Helpr?',
                style: const TextStyle(
                  fontFamily: 'HomemadeApple',
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildRoleButton(0, 'assets/Icons/i want to Hire help.png',
                  'I Want to Hire Help'),
              const SizedBox(height: 16),
              _buildRoleButton(1, 'assets/Icons/i want to offer help.png',
                  'I Want to Offer Help'),
              const SizedBox(height: 16),
              _buildRoleButton(
                  2, 'assets/Icons/i want to do both.png', 'I Want to Do Both'),
              const Spacer(),
              OutlinedButton(
                onPressed: _selectedRole != null ? _goToProfile : null,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: Colors.black, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(int value, String iconPath, String text) {
    final selected = _selectedRole == value;
    return OutlinedButton.icon(
      onPressed: () {
        setState(() {
          _selectedRole = value;
        });
      },
      icon: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Image.asset(
          iconPath,
          width: 28,
          height: 28,
        ),
      ),
      label: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.blue : Colors.black,
          fontSize: 16,
          fontFamily: 'LifeSavers',
          fontWeight: FontWeight.bold,
        ),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        side: BorderSide(
            color: selected ? Colors.blue : Colors.black, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        backgroundColor:
            selected ? Colors.blue.withOpacity(0.08) : Colors.transparent,
      ),
    );
  }
}
