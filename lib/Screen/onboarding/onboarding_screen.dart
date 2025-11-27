import 'package:flutter/material.dart';
import '../Auth/login_or_create_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginOrCreateScreen()),
      );
    }
  }

  void _close() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginOrCreateScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(24),
      ),
      child:
          const Center(child: Icon(Icons.image, size: 80, color: Colors.grey)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      // Page 1
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: _close,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome\nto\nHelpr',
              style: const TextStyle(
                fontFamily: 'HomemadeApple',
                fontSize: 38,
                height: 1.1,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            _buildImagePlaceholder(),
            const SizedBox(height: 8),
            Text(
              'Find trusted help or earn by helping others — all in your local community.',
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  height: 1.3,
                  fontFamily: 'LifeSavers'),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      // Page 2
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: _close,
              ),
            ),
            const SizedBox(height: 16),
            _buildImagePlaceholder(),
            const SizedBox(height: 8),
            Text(
              'Post or Apply\nin Minutes',
              style: const TextStyle(
                fontFamily: 'HomemadeApple',
                fontSize: 32,
                height: 1.1,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Whether you need a hand or want to lend one, creating or finding a job is fast and easy.',
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  height: 1.3,
                  fontFamily: 'LifeSavers'),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      // Page 3
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: _close,
              ),
            ),
            const SizedBox(height: 16),
            _buildImagePlaceholder(),
            const SizedBox(height: 8),
            Text(
              'Neighbors\nHelping\nNeighbors',
              style: const TextStyle(
                fontFamily: 'HomemadeApple',
                fontSize: 32,
                height: 1.1,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'We\'re building stronger communities, one job at a time.',
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  height: 1.3,
                  fontFamily: 'LifeSavers'),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: pages,
          ),
          Positioned(
            right: 24,
            bottom: 40,
            child: FloatingActionButton(
              onPressed: _nextPage,
              child: const Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }
}
