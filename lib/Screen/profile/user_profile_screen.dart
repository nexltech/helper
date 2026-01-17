import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/review_provider.dart';
import 'view_user_profile_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final int initialTabIndex;
  
  const UserProfileScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2, 
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _loadUserReviews();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadUserReviews() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    
    final user = userProvider.user;
    if (user?.token != null && user?.id != null) {
      reviewProvider.setAuthToken(user!.token!);
      reviewProvider.getUserReviews(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final user = userProvider.user;
            
            return Column(
              children: [
                // Header with back button and title
                _buildHeader(),
                
                // Profile section with circular avatar
                _buildProfileSection(user),
                
                // Tab bar
                _buildTabBar(),
                
                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAboutTab(user),
                      _buildReviewsTab(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          const Text(
            'My Profile',
            style: TextStyle(
              fontFamily: 'HomemadeApple',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        children: [
          // Circular profile picture
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.shade100,
              border: Border.all(color: Colors.green.shade300, width: 3),
            ),
            child: Center(
              child: Text(
                user?.name?.isNotEmpty == true 
                  ? user.name[0].toUpperCase() 
                  : 'U',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // User name and role
          Text(
            user?.name ?? 'User',
            style: const TextStyle(
              fontFamily: 'HomemadeApple',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            'Hire Help',
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Reviews button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.amber.shade700, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Reviews',
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.green, width: 3),
          insets: const EdgeInsets.symmetric(horizontal: 16),
        ),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(
          fontFamily: 'LifeSavers',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        tabs: const [
          Tab(text: 'About'),
          Tab(text: 'Reviews'),
        ],
      ),
    );
  }

  Widget _buildAboutTab(user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About section
          _buildSectionCard(
            title: 'About',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Skills section
          _buildSectionCard(
            title: 'Skills',
            content: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSkillTag('Cleaning'),
                _buildSkillTag('Plumbing'),
                _buildSkillTag('Electrician'),
                _buildSkillTag('Gardening'),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Contact section
          _buildSectionCard(
            title: 'Contact',
            content: Column(
              children: [
                _buildContactItem(Icons.phone, '0300-1234567'),
                const SizedBox(height: 12),
                _buildContactItem(Icons.email, user?.email ?? 'user@example.com'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, child) {
        if (reviewProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (reviewProvider.userReviews.isEmpty) {
          return const Center(
            child: Text(
              'No reviews yet',
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reviewProvider.userReviews.length,
          itemBuilder: (context, index) {
            final review = reviewProvider.userReviews[index];
            return _buildReviewCard(review);
          },
        );
      },
    );
  }

  Widget _buildSectionCard({required String title, required Widget content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'HomemadeApple',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildSkillTag(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        skill,
        style: TextStyle(
          fontFamily: 'LifeSavers',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'LifeSavers',
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    // Check if review has reviewer information
    final reviewerName = review['reviewer']?['name'] ?? review['reviewer_name'] ?? 'Anonymous';
    final reviewerId = review['reviewer']?['id'] ?? review['reviewer_id'];
    
    return GestureDetector(
      onTap: reviewerId != null ? () {
        // Navigate to reviewer's profile if available
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewUserProfileScreen(
              userId: reviewerId is int ? reviewerId : int.tryParse(reviewerId.toString()) ?? 0,
              userName: reviewerName != 'Anonymous' ? reviewerName : null,
            ),
          ),
        );
      } : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Reviewer avatar - Clickable
                if (reviewerId != null)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewUserProfileScreen(
                            userId: reviewerId is int ? reviewerId : int.tryParse(reviewerId.toString()) ?? 0,
                            userName: reviewerName != 'Anonymous' ? reviewerName : null,
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        reviewerName[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                if (reviewerId != null) const SizedBox(width: 8),
                // Reviewer name - Clickable
                if (reviewerId != null)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewUserProfileScreen(
                              userId: reviewerId is int ? reviewerId : int.tryParse(reviewerId.toString()) ?? 0,
                              userName: reviewerName != 'Anonymous' ? reviewerName : null,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        reviewerName,
                        style: const TextStyle(
                          fontFamily: 'LifeSavers',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                const Spacer(),
                // Rating
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${review['rating'] ?? '0'}',
                      style: const TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                // Date
                Text(
                  _formatDate(review['created_at'] ?? ''),
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            if (review['comment'] != null && review['comment'].toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                review['comment'],
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}