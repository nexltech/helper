import 'package:flutter/material.dart';

class ProfileNotApprovedScreen extends StatelessWidget {
  final Widget? nextScreen;
  const ProfileNotApprovedScreen({super.key, this.nextScreen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('H',
                        style: const TextStyle(
                            fontFamily: 'FrederickaTheGreat', fontSize: 65)),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Welcome,',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'BioRhyme',
                              fontWeight: FontWeight.w300)),
                      Text('Lexi L.',
                          style: const TextStyle(
                              fontFamily: 'HomemadeApple',
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.black12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.filter_alt_outlined,
                        color: Colors.black26),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: TextField(
                        style: TextStyle(fontFamily: 'LifeSavers'),
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    Icon(Icons.search, color: Colors.black26),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Main Content
            Expanded(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Text(
                          'Profile Not Approved',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            fontFamily: 'BioRhyme',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        "We've reviewed your submission and unfortunately, your profile was not approved at this time.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          fontFamily: 'BioRhyme',
                          height: 1.7,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      _infoRow(Icons.assignment_late_rounded,
                          'Your documentation did not meet our verification standards.'),
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.hourglass_empty,
                              color: Colors.amber, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'What You Can Do:',
                                  style: TextStyle(
                                    fontFamily: 'LifeSavers',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _bulletPoint(
                                    'Double-check your uploaded documents for accuracy and clarity'),
                                _bulletPoint(
                                    'Ensure all fields are completed correctly'),
                                _bulletPoint(
                                    'Submit any missing or updated information'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      OutlinedButton(
                        onPressed: () {
                          if (nextScreen != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => nextScreen!),
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          side:
                              const BorderSide(color: Colors.black, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text(
                          'Review Profile',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'BioRhyme',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.redAccent, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 18, fontFamily: 'LifeSavers', height: 1.7),
          ),
        ),
      ],
    );
  }

  static Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ',
              style: TextStyle(fontSize: 20, fontFamily: 'LifeSavers')),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 18, fontFamily: 'LifeSavers', height: 1.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: const Icon(Icons.home_outlined), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.assignment_outlined), onPressed: () {}),
          Container(
            decoration: BoxDecoration(
              color: Colors.green[100],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.add, size: 32, color: Colors.green),
              onPressed: () {},
            ),
          ),
          IconButton(
              icon: const Icon(Icons.chat_bubble_outline), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}),
        ],
      ),
    );
  }
}
