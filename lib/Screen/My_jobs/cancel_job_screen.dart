import 'package:flutter/material.dart';
import 'package:job/Screen/My_jobs/my_jobs_screen.dart';
import 'package:job/Screen/My_jobs/job_canceled_screen.dart';

class CancelJobScreen extends StatefulWidget {
  const CancelJobScreen({super.key});

  @override
  State<CancelJobScreen> createState() => _CancelJobScreenState();
}

class _CancelJobScreenState extends State<CancelJobScreen> {
  int selectedReason = 0;
  final TextEditingController _controller = TextEditingController();

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
                    'Cancel Job',
                    style: const TextStyle(
                      fontFamily: 'HomemadeApple',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "We understand things don’t always go as planned. Let us know why you're canceling so we can improve your experience in the future.",
                  style: const TextStyle(
                    fontFamily: 'BioRhyme',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Select a reason: (required)',
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                _buildCheckbox(0, 'I no longer need the service'),
                _buildCheckbox(1, 'I found someone outside Helpr'),
                _buildCheckbox(2, 'Other:'),
                const SizedBox(height: 10),
                const Text(
                  'Comments',
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFB0B0B0)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 8),
                        child: Icon(Icons.chat_bubble_outline,
                            color: Colors.grey[700], size: 28),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          minLines: 2,
                          maxLines: 3,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
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
                          side: const BorderSide(color: Colors.black, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 0),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "BioRhyme",
                            // fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const JobCanceledScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 0),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              color: Colors.black, fontFamily: "bioRhyme"
                              //  fontWeight: FontWeight.w400,
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
    );
  }

  Widget _buildCheckbox(int value, String text) {
    return Row(
      children: [
        Checkbox(
          value: selectedReason == value,
          onChanged: (val) {
            setState(() {
              selectedReason = value;
            });
          },
          activeColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          side: const BorderSide(color: Colors.black, width: 1),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'LifeSavers',
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
