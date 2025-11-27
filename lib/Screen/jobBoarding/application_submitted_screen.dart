import 'package:flutter/material.dart';
import 'package:job/Screen/jobBoarding/navbar.dart';
import 'package:job/Screen/jobBoarding/job_board_main_screen.dart';
import 'package:job/Screen/My_jobs/my_jobs_screen.dart';

class ApplicationSubmittedScreen extends StatelessWidget {
  const ApplicationSubmittedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.black26, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Application Submitted',
                      style: const TextStyle(
                        fontFamily: 'HomemadeApple',
                        fontSize: 48,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      "You've successfully applied for this job.",
                      style: const TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Use a thumbs up icon or asset
                      Icon(Icons.thumb_up_alt_rounded,
                          color: Colors.green, size: 36),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "The client has been notified and can review your profile and reach out. We'll let you know if you're selected.  In the meantime:\n  • View other jobs in your area\n  • Check your application status anytime",
                          style: const TextStyle(
                            fontFamily: 'LifeSavers',
                            fontSize: 22,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const JobBoardMainScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black54, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          child: Text(
                            'Jobs',
                            style: const TextStyle(
                              fontFamily: 'LifeSavers',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyJobsScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black54, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          child: Text(
                            'Applications',
                            style: const TextStyle(
                              fontFamily: 'LifeSavers',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
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
