import 'package:flutter/material.dart';
import 'package:job/Screen/jobBoarding/application_submitted_screen.dart';
import 'package:job/Screen/jobBoarding/navbar.dart';
import 'package:job/Screen/profile/client_profile_screen.dart';
import 'package:job/Screen/profile/worker_profile_screen.dart';
import 'package:job/Screen/profile/both_profile_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/crud_job_provider.dart';
import '../../models/job_model.dart';

class ConfirmApplicationScreen extends StatefulWidget {
  final JobPost job;
  
  const ConfirmApplicationScreen({
    super.key,
    required this.job,
  });

  @override
  State<ConfirmApplicationScreen> createState() => _ConfirmApplicationScreenState();
}

class _ConfirmApplicationScreenState extends State<ConfirmApplicationScreen> {
  final TextEditingController _coverLetterController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set auth token for job provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final jobProvider = Provider.of<CrudJobProvider>(context, listen: false);
      
      if (userProvider.user?.token != null) {
        jobProvider.setAuthToken(userProvider.user!.token!);
      }
    });
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
      backgroundColor: Colors.white,
      body: Consumer<CrudJobProvider>(
        builder: (context, jobProvider, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: 360,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Confirm Application',
                          style: const TextStyle(
                            fontFamily: 'HomemadeApple',
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Are you sure you want to apply?',
                          style: const TextStyle(
                            fontFamily: 'LifeSavers',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Job Title Display
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Job: ${widget.job.jobTitle}',
                              style: const TextStyle(
                                fontFamily: 'LifeSavers',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Payment: \$${widget.job.payment}',
                              style: const TextStyle(
                                fontFamily: 'LifeSavers',
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 24),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Once you apply, the job poster will see your profile. You won't be able to edit your application after submitting.",
                              style: const TextStyle(
                                fontFamily: 'LifeSavers',
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.note, color: Colors.black54, size: 24),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Quick Reminders:',
                                  style: const TextStyle(
                                    fontFamily: 'LifeSavers',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '• Make sure your information, bio, and skills are up to date.\n• You can withdraw your application later if needed.',
                                  style: const TextStyle(
                                    fontFamily: 'LifeSavers',
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      // Error/Success Messages
                      if (jobProvider.errorMessage != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
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
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                _navigateToProfile(context);
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.black54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(
                                'Review Profile',
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
                              onPressed: jobProvider.isLoading ? null : () {
                                _applyForJob(context, jobProvider);
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.black54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: jobProvider.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : Text(
                                      'Yes, Apply Now',
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
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  void _applyForJob(BuildContext context, CrudJobProvider jobProvider) async {
    // Default cover letter and availability for now
    // In a real app, you might want to collect this from the user
    const String coverLetter = "I am interested in this job and would like to apply. I have the necessary skills and experience for this position.";
    const List<String> availability = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
    
    try {
      await jobProvider.applyForJob(
        jobId: widget.job.id,
        coverLetter: coverLetter,
        availability: availability,
      );
      
      // If successful, navigate to success screen
      if (jobProvider.successMessage != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ApplicationSubmittedScreen(),
          ),
        );
      }
    } catch (e) {
      // Error is already handled by the provider and displayed in the UI
      print('Error applying for job: $e');
    }
  }

  void _navigateToProfile(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    
    Widget profileScreen;
    
    if (user?.role == 'hire_help') {
      profileScreen = const ClientProfileScreen();
    } else if (user?.role == 'offer_help') {
      profileScreen = const WorkerProfileScreen();
    } else {
      profileScreen = const BothProfileScreen();
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => profileScreen),
    );
  }
}
