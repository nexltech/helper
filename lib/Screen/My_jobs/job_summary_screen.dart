import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:job/Screen/My_jobs/job_posted_dialog.dart';
import '../../providers/crud_job_provider.dart';
import '../../providers/user_provider.dart';

class JobSummaryScreen extends StatefulWidget {
  final String jobTitle;
  final int jobCategoryId;
  final double payment;
  final String address;
  final String dateTime;
  final String jobDescription; 
  final File selectedImage;

  const JobSummaryScreen({
    super.key,
    required this.jobTitle,
    required this.jobCategoryId,
    required this.payment,
    required this.address,
    required this.dateTime,
    required this.jobDescription,
    required this.selectedImage,
  });

  @override
  State<JobSummaryScreen> createState() => _JobSummaryScreenState();
}

class _JobSummaryScreenState extends State<JobSummaryScreen> {
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
  Widget build(BuildContext context) {
    return Consumer<CrudJobProvider>(
      builder: (context, jobProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Error Messages
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
                    // Header
                    _buildHeader(context),
                    const SizedBox(height: 24),
                    // Job Summary Card
                    _buildJobSummaryCard(),
                    const SizedBox(height: 24),
                    // Submit Button
                    _buildSubmitButton(context, jobProvider),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 8),
        const Text(
          'Job Summary',
          style: TextStyle(
            fontFamily: 'HomemadeApple',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildJobSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job Poster Info
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/women/65.jpg',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.jobTitle,
                      style: const TextStyle(
                        fontFamily: 'FrederickaTheGreat',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Posted by: Kaci L.',
                      style: TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        const Text(
                          '4.8 (28 Reviews)',
                          style: TextStyle(
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
          
          // Job Details
          _buildJobDetails(),
          const SizedBox(height: 20),
          
          // Job Description
          _buildJobDescription(),
          const SizedBox(height: 20),
          
          // Job Images
          _buildJobImages(),
        ],
      ),
    );
  }

  Widget _buildJobDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Job Details',
          style: TextStyle(
            fontFamily: 'LifeSavers',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildDetailItem(Icons.attach_money, '\$${widget.payment.toStringAsFixed(0)}', Colors.green),
            _buildDetailItem(Icons.calendar_today, widget.dateTime.split(' ')[0], Colors.blue),
            _buildDetailItem(Icons.access_time, widget.dateTime.split(' ')[1], Colors.orange),
            _buildDetailItem(Icons.home, 'Category ID: ${widget.jobCategoryId}', Colors.purple),
            _buildDetailItem(Icons.location_on, widget.address, Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 13,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildJobDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontFamily: 'LifeSavers',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            widget.jobDescription,
            style: const TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJobImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Image',
          style: TextStyle(
            fontFamily: 'LifeSavers',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              widget.selectedImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, CrudJobProvider jobProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: jobProvider.isLoading ? null : () => _handleSubmit(context, jobProvider),
        style: ElevatedButton.styleFrom(
          backgroundColor: jobProvider.isLoading ? Colors.grey[300] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: jobProvider.isLoading ? Colors.grey : Colors.black,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
        ),
        child: jobProvider.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : const Text(
                'Submit',
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
      ),
    );
  }

  void _handleSubmit(BuildContext context, CrudJobProvider jobProvider) async {
    try {
      // Clear any previous messages
      jobProvider.clearMessages();
      
      // Create the job post
      await jobProvider.createJobPost(
        jobTitle: widget.jobTitle,
        jobCategoryId: widget.jobCategoryId,
        payment: widget.payment,
        address: widget.address,
        dateTime: widget.dateTime,
        jobDescription: widget.jobDescription,
        image: widget.selectedImage.path,
      );

      // Check if job was created successfully
      if (jobProvider.successMessage != null && jobProvider.errorMessage == null) {
        // Show job posted dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const JobPostedDialog();
          },
        );
      }
    } catch (e) {
      // Error handling is done in the provider
      print('Error creating job: $e');
    }
  }
}
