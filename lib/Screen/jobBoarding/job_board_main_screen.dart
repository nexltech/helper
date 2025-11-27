import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:job/Screen/jobBoarding/job_details_screen.dart';
import 'package:job/Screen/jobBoarding/confirm_application_screen.dart';
import 'package:job/Screen/jobBoarding/navbar.dart';
import 'package:job/Screen/My_jobs/Review_screen.dart';
import 'package:job/Screen/My_jobs/job_post_screen.dart';
import '../../providers/crud_job_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/job_model.dart';

class JobBoardMainScreen extends StatefulWidget {
  const JobBoardMainScreen({super.key});

  @override
  State<JobBoardMainScreen> createState() => _JobBoardMainScreenState();
}

class _JobBoardMainScreenState extends State<JobBoardMainScreen> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadJobs();
    });
  }

  void _loadJobs() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final jobProvider = Provider.of<CrudJobProvider>(context, listen: false);
    
    if (userProvider.user?.token != null) {
      jobProvider.setAuthToken(userProvider.user!.token!);
      jobProvider.getActiveJobs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Consumer<CrudJobProvider>(
          builder: (context, jobProvider, child) {
            return Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo/Initial
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'H',
                          style: const TextStyle(
                            fontFamily: 'FrederickatheGreat',
                            fontSize: 40,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Welcome text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome.',
                              style: const TextStyle(
                                fontFamily: 'FrederickatheGreat',
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '${Provider.of<UserProvider>(context, listen: false).user?.name ?? 'User'}',
                              style: const TextStyle(
                                fontFamily: 'FrederickatheGreat',
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Bell icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Icon(
                            Icons.search,
                            color: Colors.black54,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Search',
                          style: TextStyle(
                            fontFamily: 'LifeSavers',
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Error Messages
                if (jobProvider.errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Text(
                      'Error: ${jobProvider.errorMessage}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                
                // Jobs List
                Expanded(
                  child: jobProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : jobProvider.jobs.isEmpty
                          ? const Center(
                              child: Text(
                                'No active jobs available at the moment',
                                style: TextStyle(
                                  fontFamily: 'LifeSavers',
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () async {
                                await jobProvider.getActiveJobs();
                              },
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                itemCount: jobProvider.jobs.length,
                                itemBuilder: (context, index) {
                                  final job = jobProvider.jobs[index];
                                  return _buildJobCard(job, jobProvider);
                                },
                              ),
                            ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const JobPostScreen(),
              ),
            );
          },
          backgroundColor: const Color(0xFFDDF8E5),
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.green, size: 48),
        ),
      ),
    );
  }

  Widget _buildJobCard(JobPost job, CrudJobProvider jobProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE3F2FD), // Light blue border
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section: Profile Picture, Job Title, and Poster Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              CircleAvatar(
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
              const SizedBox(width: 16),
              // Job Title and Poster Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Job Title
                    Text(
                      job.jobTitle.isNotEmpty ? job.jobTitle : 'Untitled Job',
                      style: const TextStyle(
                        fontFamily: 'HomemadeApple',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                   
                    // Rating
                    Row(
                      children: [
                         // Posted by info - Show user name instead of ID
                    Text(
                      'Posted by: ${job.user?.name ?? job.userId}',
                      style: const TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 14,
                        color: Colors.black87,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                      ),
                    ),
                    SizedBox(width: 2,),
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '4.8 (23 Reviews)',
                          style: const TextStyle(
                            fontFamily: 'LifeSavers',
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 10),
          
          // Job Details Section - Single horizontal scrollable row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Payment
                _buildJobDetailItem(
                  icon: Icons.account_balance_wallet,
                  iconColor: Colors.green,
                  text: '\$${job.payment}',
                ),
                _buildSeparator(),
                // Date & Time
                _buildJobDetailItem(
                  icon: Icons.calendar_today,
                  iconColor: Colors.blue,
                  text: _formatDate(job.dateTime),
                ),
                _buildSeparator(),
                // Location
                _buildJobDetailItem(
                  icon: Icons.location_on,
                  iconColor: Colors.red,
                  text: job.address.isNotEmpty ? job.address : 'No address provided',
                ),
                _buildSeparator(),
                // Category
                _buildJobDetailItem(
                  icon: Icons.home,
                  iconColor: Colors.orange,
                  text: job.category.name.isNotEmpty ? job.category.name : 'Home Services',
                ),
              ],
            ),
          ),
          
          // Application Status (if applied)
          if (jobProvider.isJobApplied(job.id)) ...[
            const SizedBox(height: 12),
            _buildApplicationStatusRow(job, jobProvider),
          ],
          
          const SizedBox(height: 10),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailsScreen(job: job),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Details',
                    style: TextStyle(
                      fontFamily: 'LifeSavers',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildApplyButton(job, jobProvider),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetailItem({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      height: 20,
      width: 1,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildApplicationStatusRow(JobPost job, CrudJobProvider jobProvider) {
    final status = jobProvider.getApplicationStatus(job.id) ?? 'pending';
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);
    final statusText = _getStatusText(status);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          const SizedBox(width: 8),
          Text(
            'Application Status: $statusText',
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
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

  Widget _buildApplyButton(JobPost job, CrudJobProvider jobProvider) {
    final isApplied = jobProvider.isJobApplied(job.id);
    final status = jobProvider.getApplicationStatus(job.id);
    
    if (isApplied) {
      // Check if job is completed
      if (status?.toLowerCase() == 'completed') {
        return Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.green,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'COMPLETED',
                      style: const TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewScreen(
                        applicationId: job.id, // Using job.id as applicationId for now
                        jobTitle: job.jobTitle,
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  'Review',
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: _getStatusColor(status ?? 'pending'),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: _getStatusColor(status ?? 'pending'),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getStatusIcon(status ?? 'pending'),
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                _getStatusText(status ?? 'pending'),
                style: const TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      }
    } else {
      return OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmApplicationScreen(job: job),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.black, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: Colors.white,
        ),
        child: const Text(
          'Apply',
          style: TextStyle(
            fontFamily: 'LifeSavers',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'accepted':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.info;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Applied';
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Applied';
    }
  }
}