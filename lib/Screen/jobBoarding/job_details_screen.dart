import 'package:flutter/material.dart';
import 'package:job/Screen/jobBoarding/confirm_application_screen.dart';
import 'package:job/Screen/jobBoarding/report_job_screen.dart';
import 'package:job/Screen/profile/view_user_profile_screen.dart';
import '../../models/job_model.dart';

class JobDetailsScreen extends StatelessWidget {
  final JobPost job;
  
  const JobDetailsScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Header with back arrow and title
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 24),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Job Details',
                      style: const TextStyle(
                        fontFamily: 'HomemadeApple',
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Job title and poster
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture - Clickable
                    GestureDetector(
                      onTap: () => _navigateToUserProfile(context, job),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          job.user?.name.isNotEmpty == true 
                            ? job.user!.name[0].toUpperCase()
                            : (job.jobTitle.isNotEmpty ? job.jobTitle[0].toUpperCase() : 'J'),
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.jobTitle.isNotEmpty ? job.jobTitle : 'Untitled Job',
                            style: const TextStyle(
                              fontFamily: 'FrederickatheGreat',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              // Posted by - Clickable
                              GestureDetector(
                                onTap: () => _navigateToUserProfile(context, job),
                                child: Text(
                                  'Posted by: ${job.user?.name ?? (job.userId.isNotEmpty ? job.userId : 'Unknown')}',
                                  style: const TextStyle(
                                    fontFamily: 'LifeSavers',
                                    fontSize: 14,
                                    color: Colors.black87,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blue,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Reviews - Clickable
                              GestureDetector(
                                onTap: () => _navigateToUserProfileReviews(context, job),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 16),
                                    const SizedBox(width: 2),
                                    Text(
                                      '4.8 (23 Reviews)',
                                      style: const TextStyle(
                                        fontFamily: 'LifeSavers',
                                        fontSize: 13,
                                        color: Colors.black54,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Info Card with all content
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.account_balance_wallet, size: 24, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              '\$${job.payment}',
                              style: const TextStyle(
                                fontFamily: 'LifeSavers',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 24, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              _formatDate(job.dateTime),
                              style: const TextStyle(
                                fontFamily: 'LifeSavers',
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 24, color: Colors.black54),
                            const SizedBox(width: 8),
                            Text(
                              _formatTime(job.dateTime),
                              style: const TextStyle(
                                fontFamily: 'LifeSavers',
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.home, size: 24, color: Colors.orange),
                            const SizedBox(width: 8),
                            Text(
                              job.category.name.isNotEmpty ? job.category.name : 'Home Services',
                              style: const TextStyle(
                                fontFamily: 'LifeSavers',
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on, size: 24, color: Colors.redAccent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                job.address.isNotEmpty ? job.address : 'No address provided',
                                style: const TextStyle(
                                  fontFamily: 'LifeSavers',
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Description
                        Text(
                          job.jobDescription.isNotEmpty ? job.jobDescription : 'No description provided',
                          style: const TextStyle(
                            fontFamily: 'LifeSavers',
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Images
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1519710164239-da123dc03ef4?auto=format&fit=crop&w=400&q=80',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ReportJobScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Report',
                          style: const TextStyle(
                            fontFamily: 'LifeSavers',
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                   ConfirmApplicationScreen(job: job),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Apply',
                          style: const TextStyle(
                            fontFamily: 'LifeSavers',
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) {
      return 'No date provided';
    }
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  String _formatTime(String dateString) {
    if (dateString.isEmpty) {
      return 'No time provided';
    }
    try {
      final date = DateTime.parse(dateString);
      final hour = date.hour;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } catch (e) {
      return 'Invalid time';
    }
  }

  void _navigateToUserProfile(BuildContext context, JobPost job) {
    if (job.user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewUserProfileScreen(
            userId: job.user!.id,
            userName: job.user!.name,
            userEmail: job.user!.email,
          ),
        ),
      );
    } else if (job.userId.isNotEmpty) {
      // Try to parse userId as int
      final userId = int.tryParse(job.userId);
      if (userId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewUserProfileScreen(
              userId: userId,
              userName: job.userId,
            ),
          ),
        );
      }
    }
  }

  void _navigateToUserProfileReviews(BuildContext context, JobPost job) {
    if (job.user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewUserProfileScreen(
            userId: job.user!.id,
            userName: job.user!.name,
            userEmail: job.user!.email,
            initialTabIndex: 1, // Open to Reviews tab
          ),
        ),
      );
    } else if (job.userId.isNotEmpty) {
      // Try to parse userId as int
      final userId = int.tryParse(job.userId);
      if (userId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewUserProfileScreen(
              userId: userId,
              userName: job.userId,
              initialTabIndex: 1, // Open to Reviews tab
            ),
          ),
        );
      }
    }
  }
}
