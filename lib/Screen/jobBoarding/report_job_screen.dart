import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:job/Screen/jobBoarding/navbar.dart';
import 'package:job/Screen/jobBoarding/job_details_screen.dart';
import '../../providers/crud_job_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/my_applications_provider.dart';
import '../../models/job_model.dart';
import '../../models/my_application_model.dart';

class ReportJobScreen extends StatefulWidget {
  const ReportJobScreen({super.key});

  @override
  State<ReportJobScreen> createState() => _ReportJobScreenState();
}

class _ReportJobScreenState extends State<ReportJobScreen> {
  final TextEditingController _coverLetterController = TextEditingController();
  final List<String> _availability = [];
  final TextEditingController _availabilityController = TextEditingController();

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
    final applicationsProvider = Provider.of<MyApplicationsProvider>(context, listen: false);
    
    if (userProvider.user?.token != null) {
      jobProvider.setAuthToken(userProvider.user!.token!);
      applicationsProvider.setAuthToken(userProvider.user!.token!);
      jobProvider.getActiveJobs();
      applicationsProvider.getMyApplications();
    }
  }

  @override
  void dispose() {
    _coverLetterController.dispose();
    _availabilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Consumer2<CrudJobProvider, MyApplicationsProvider>(
          builder: (context, jobProvider, applicationsProvider, child) {
            return Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios, size: 20),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Jobs & Applications',
                        style: TextStyle(
                          fontFamily: 'LifeSavers',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Error/Success Messages
                if (jobProvider.errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(16),
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
                  child: (jobProvider.isLoading || applicationsProvider.isLoading)
                      ? const Center(child: CircularProgressIndicator())
                      : (jobProvider.jobs.isEmpty && applicationsProvider.applications.isEmpty)
                          ? const Center(
                              child: Text(
                                'No jobs or applications available at the moment',
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
                                await applicationsProvider.getMyApplications();
                              },
                              child: ListView(
                                padding: const EdgeInsets.all(16),
                                children: [
                                  // Applied Jobs Section
                                  if (applicationsProvider.applications.isNotEmpty) ...[
                                    _buildSectionHeader('My Applications', applicationsProvider.applications.length),
                                    const SizedBox(height: 12),
                                    ...applicationsProvider.applications.map((application) => 
                                      _buildApplicationCard(application)
                                    ).toList(),
                                    const SizedBox(height: 24),
                                  ],
                                  
                                  // Active Jobs Section
                                  if (jobProvider.jobs.isNotEmpty) ...[
                                    _buildSectionHeader('Available Jobs', jobProvider.jobs.length),
                                    const SizedBox(height: 12),
                                    ...jobProvider.jobs.map((job) => 
                                      _buildJobCard(job)
                                    ).toList(),
                                  ],
                                ],
                              ),
                            ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(MyApplication application) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor(application.status),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor(application.status).withOpacity(0.1),
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
              Icon(
                _getStatusIcon(application.status),
                color: _getStatusColor(application.status),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                application.jobPost.jobTitle,
                style: const TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(application.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  application.status.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(application.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Applied on: ${_formatDate(application.createdAt)}',
            style: const TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          if (application.coverLetter.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Cover Letter: ${application.coverLetter}',
              style: const TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 14,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
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

  String _formatDate(String dateString) {
    if (dateString.isEmpty) {
      return 'Unknown date';
    }
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  Widget _buildJobCard(JobPost job) {
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
                    const SizedBox(height: 4),
                    // Rating
                    Row(
                      children: [
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
          
          const SizedBox(height: 20),
          
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
          
          const SizedBox(height: 24),
          
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
                child: OutlinedButton(
                  onPressed: () => _showApplicationDialog(job),
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
                ),
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



  void _showApplicationDialog(JobPost job) {
    _coverLetterController.clear();
    _availability.clear();
    _availabilityController.clear();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Confirm Application',
                  style: TextStyle(
                    fontFamily: 'HomemadeApple',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Are you sure you want to apply?',
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                    children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Once you apply, the job poster will see your profile. You won\'t be able to edit your application after submitting.',
                        style: TextStyle(
                          fontFamily: 'LifeSavers',
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.folder, color: Colors.grey, size: 16),
                    const SizedBox(width: 8),
                      Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Reminders:',
                            style: TextStyle(
                              fontFamily: 'LifeSavers',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '• Make sure your information, bio, and skills are up to date.',
                            style: TextStyle(
                              fontFamily: 'LifeSavers',
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '• You can withdraw your application later if needed.',
                            style: TextStyle(
                              fontFamily: 'LifeSavers',
                              fontSize: 12,
                              color: Colors.grey[600],
                        ),
                      ),
                    ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Review Profile',
                          style: TextStyle(
                            fontFamily: 'LifeSavers',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showApplicationForm(job);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Yes, Apply Now',
                          style: TextStyle(
                            fontFamily: 'LifeSavers',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showApplicationForm(JobPost job) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Apply for ${job.jobTitle}',
                  style: const TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _coverLetterController,
                  decoration: const InputDecoration(
                    labelText: 'Cover Letter',
                    hintText: 'Tell them why you\'re perfect for this job...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _availabilityController,
                  decoration: const InputDecoration(
                    labelText: 'Availability (comma-separated dates)',
                    hintText: '2025-09-20 10:00, 2025-09-21 14:00',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _availability.addAll(value.split(',').map((e) => e.trim()));
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _submitApplication(job),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Submit Application',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitApplication(JobPost job) async {
    print('=== SUBMIT APPLICATION DEBUG ===');
    print('Job ID: ${job.id}');
    print('Job Title: ${job.jobTitle}');
    print('Cover Letter: ${_coverLetterController.text}');
    print('Availability Input: ${_availabilityController.text}');

    if (_coverLetterController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a cover letter'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final availability = _availabilityController.text.isNotEmpty
        ? _availabilityController.text.split(',').map((e) => e.trim()).toList()
        : ['2025-09-20 10:00', '2025-09-21 14:00']; // Default availability

    print('Final Availability: $availability');

    final jobProvider = Provider.of<CrudJobProvider>(context, listen: false);
    
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Submitting application...'),
            ],
          ),
        );
      },
    );
    
    try {
      print('Calling applyForJob...');
      await jobProvider.applyForJob(
        jobId: job.id,
        coverLetter: _coverLetterController.text,
        availability: availability,
      );

      print('Apply for job completed. Success: ${jobProvider.successMessage}');
      print('Apply for job completed. Error: ${jobProvider.errorMessage}');

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        
        if (jobProvider.errorMessage != null) {
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${jobProvider.errorMessage}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        } else {
          // Show success
          Navigator.pop(context); // Close application form
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(jobProvider.successMessage ?? 'Application submitted successfully!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      print('Exception in _submitApplication: $e');
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit application: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}
