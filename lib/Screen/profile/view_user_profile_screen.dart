import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/review_provider.dart';
import '../../models/job_model.dart';

class ViewUserProfileScreen extends StatefulWidget {
  final int userId;
  final String? userName;
  final String? userEmail;
  final int initialTabIndex;
  
  const ViewUserProfileScreen({
    super.key,
    required this.userId,
    this.userName,
    this.userEmail,
    this.initialTabIndex = 0,
  });

  @override
  State<ViewUserProfileScreen> createState() => _ViewUserProfileScreenState();
}

class _ViewUserProfileScreenState extends State<ViewUserProfileScreen> with SingleTickerProviderStateMixin {
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
    if (user?.token != null) {
      reviewProvider.setAuthToken(user!.token!);
      reviewProvider.getReviewsForUser(widget.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            _buildHeader(),
            
            // Profile section with circular avatar
            _buildProfileSection(),
            
            // Tab bar
            _buildTabBar(),
            
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAboutTab(),
                  _buildReviewsTab(),
                ],
              ),
            ),
          ],
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
          Text(
            widget.userName ?? 'User Profile',
            style: const TextStyle(
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

  Widget _buildProfileSection() {
    final displayName = widget.userName ?? 'User';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';
    
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
                initial,
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
            displayName,
            style: const TextStyle(
              fontFamily: 'HomemadeApple',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            widget.userEmail ?? '',
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Reviews button
          Consumer<ReviewProvider>(
            builder: (context, reviewProvider, child) {
              final totalReviews = reviewProvider.getTotalReviews();
              final avgRating = reviewProvider.getAverageRating();
              
              return Container(
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
                      avgRating > 0 
                        ? '${avgRating.toStringAsFixed(1)} ($totalReviews Reviews)'
                        : 'Reviews',
                      style: TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade700,
                      ),
                    ),
                  ],
                ),
              );
            },
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

  Widget _buildAboutTab() {
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
                  'This user hasn\'t added a bio yet.',
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
          
          // Contact section
          _buildSectionCard(
            title: 'Contact',
            content: Column(
              children: [
                if (widget.userEmail != null)
                  _buildContactItem(Icons.email, widget.userEmail!),
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

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 14,
              color: Colors.grey[700],
            ),
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
                // Reviewer avatar
                if (reviewerId != null)
                  CircleAvatar(
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
                if (reviewerId != null) const SizedBox(width: 8),
                // Reviewer name
                if (reviewerId != null)
                  Expanded(
                    child: Text(
                      reviewerName,
                      style: const TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
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

