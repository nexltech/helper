import 'package:flutter/material.dart';
import 'package:job/Screen/My_jobs/my_jobs_screen.dart';

class JobCanceledScreen extends StatelessWidget {
  const JobCanceledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black54, width: 1),
            ),
            width: 370,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Job Canceled',
                    style: const TextStyle(
                      fontFamily: 'HomemadeApple',
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "We’ve removed this job from your active list. Any involved parties have been notified.",
                  style: const TextStyle(
                    fontFamily: 'bioRhyme',
                    //fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'What happens next?',
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 2),
                      _BulletText(
                          'If a payment was made, it will be refunded according to our policy.'),
                      _BulletText(
                          'If a worker was assigned, they’ve been notified of the cancellation.'),
                      _BulletText(
                          'You can always post a new job when you’re ready.'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Icon(Icons.menu_book,
                          color: Colors.black54, size: 20),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Need help?',
                            style: TextStyle(
                              fontFamily: 'LifeSavers',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'If this was a mistake or you need assistance, contact us at support@helprapp.com',
                            style: TextStyle(
                              fontFamily: 'LifeSavers',
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Center(
                  child: SizedBox(
                    width: 160,
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
                        side: const BorderSide(color: Colors.black, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      child: const Text(
                        'Ok',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "bioRhyme",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BulletText extends StatelessWidget {
  final String text;
  const _BulletText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16, height: 1.3)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 15,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
