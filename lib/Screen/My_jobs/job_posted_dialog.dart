import 'package:flutter/material.dart';
import 'package:job/Screen/My_jobs/my_jobs_screen.dart';

class JobPostedDialog extends StatelessWidget {
  const JobPostedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            
            // Title
            const Text(
              'Job Posted',
              style: TextStyle(
                fontFamily: 'HomemadeApple',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            
            // Success Message
            const Text(
              'Your job is now live.\nAnyone can apply and you\'ll be\nnotified as soon as someone does.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 16,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            
            // OK Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handleOk(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black, width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
                child: const Text(
                  'Ok',
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleOk(BuildContext context) {
    // Close dialog
    Navigator.of(context).pop();
    
    // Navigate back to My Jobs screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MyJobsScreen(),
      ),
      (route) => false,
    );
  }
}
