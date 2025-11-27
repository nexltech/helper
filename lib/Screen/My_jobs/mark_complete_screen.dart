import 'package:flutter/material.dart';

class MarkCompleteScreen extends StatelessWidget {
  const MarkCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // Explicitly set Scaffold background to white
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: true,
              elevation: 0,
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              title: const SizedBox(),
              pinned:
                  false, // Set to true if you want the AppBar to stay visible
              flexibleSpace: FlexibleSpaceBar(
                background:
                    Container(color: Colors.white), // Ensures no graying
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_box, color: Colors.green, size: 32),
                      SizedBox(width: 8, height: 32),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Mark Job as Complete',
                          style: TextStyle(
                            fontFamily: 'HomemadeApple',
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Is this job finished?\n**Marking this job as complete confirms that the work has been successfully done and allows us to proceed with payment and feedback.**',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'LifeSavers',
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'What happens next?',
                      style: TextStyle(
                        fontFamily: 'BioRhyme',
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Confirming marks the job as done from your side.\nPayment will be released once both sides have confirmed.',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'LifeSavers',
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        margin: const EdgeInsets.only(top: 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.chat_bubble_outline,
                                color: Color(0xFFB3AEE2), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 24,
                        top: 2,
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: const Text(
                            'Optional Notes',
                            style: TextStyle(
                              fontFamily: 'LifeSavers',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Please review:',
                      style: TextStyle(
                        fontFamily: 'BioRhyme',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '• This action cannot be undone.\n• If you experienced an issue, please report it before confirming.',
                      style: TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Confirmation logic here
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Yes, Mark as Complete',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Back',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Repost logic here
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Repost Job',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
