import 'package:flutter/material.dart';
import '../../services/profile_api_service.dart';
import '../../Screen/My_jobs/job_post_screen.dart';
import 'profile_not_approved_screen.dart';

class ProfilePendingReviewScreen extends StatefulWidget {
  const ProfilePendingReviewScreen({super.key});

  @override
  State<ProfilePendingReviewScreen> createState() => _ProfilePendingReviewScreenState();
}

class _ProfilePendingReviewScreenState extends State<ProfilePendingReviewScreen> {
  bool _isLoading = true;
  String _status = 'pending';

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    try {
      final response = await ProfileApiService.checkUserStatus();
      if (response != null) {
        setState(() {
          _status = response['status'] ?? 'pending';
          _isLoading = false;
        });

        // Navigate based on status
        if (_status == 'approved') {
          // User is approved, navigate to job post screen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const JobPostScreen(),
              ),
            );
          });
        } else if (_status == 'rejected') {
          // User is rejected, navigate to not approved screen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ProfileNotApprovedScreen(),
              ),
            );
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error checking status: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
                            fontFamily: 'FrederickaTheGreat', fontSize: 36)),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Welcome,',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'BioRhyme',
                              height: 1.6)),
                      Text('Lexi L.',
                          style: const TextStyle(
                              fontFamily: 'HomemadeApple',
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Image.asset('assets/Icons/Bell.png',
                        width: 48, height: 48),
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
                  child: _isLoading
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Checking your status...'),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 32.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.verified,
                                      color: Colors.green, size: 28),
                                  const SizedBox(width: 8),
                                  const Text('Profile Pending Review',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                        fontFamily: 'BioRhyme',
                                        height: 1.5,
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Thank you for submitting your profile!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: 'BioRhyme',
                                  height: 1.7),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 28),
                            _infoRow('assets/Icons/reiew.png',
                                'We are currently reviewing your details. This usually takes up to 24 hours.'),
                            const SizedBox(height: 18),
                            _infoRow('assets/Icons/Check.png',
                                'Check back in the app to see if you\'ve been approved.'),
                            const SizedBox(height: 18),
                            _infoRow('assets/Icons/Full access.png',
                                'Once approved, you\'ll unlock full access to job features!'),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _checkUserStatus,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 12),
                              ),
                              child: const Text(
                                'Check Status',
                                style: TextStyle(
                                  fontSize: 16,
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

  static Widget _infoRow(dynamic icon, String text,
      {List<String>? extraIcons}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon is String)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Image.asset(icon, width: 36, height: 36),
          )
        else if (icon is IconData)
          Icon(icon, color: Colors.teal, size: 22),
        if (extraIcons != null)
          ...extraIcons.map((path) => Padding(
                padding: const EdgeInsets.only(left: 4.0, top: 2.0),
                child: Image.asset(path, width: 36, height: 36),
              )),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 22, fontFamily: 'LifeSavers', height: 2.0),
          ),
        ),
      ],
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
