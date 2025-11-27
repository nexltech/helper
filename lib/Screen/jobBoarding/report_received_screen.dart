import 'package:flutter/material.dart';
import 'package:job/Screen/jobBoarding/navbar.dart';

class ReportReceivedScreen extends StatelessWidget {
  const ReportReceivedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: 360,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Report Received',
                      style: const TextStyle(
                        fontFamily: 'HomemadeApple',
                        fontSize: 36,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      "We'll review your report within 24 hours and follow up via email or in-app messaging.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lock_outline, color: Colors.black54, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Your report is private.',
                        style: const TextStyle(
                          fontFamily: 'LifeSavers',
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      'Only our internal support and safety teams will see it. We do not share your identity without consent unless legally required.',
                      style: const TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            'Ok',
                            style: const TextStyle(
                              fontFamily: 'LifeSavers',
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
