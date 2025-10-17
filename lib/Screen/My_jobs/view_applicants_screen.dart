import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/applicant_model.dart';
import '../../providers/job_applicants_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/chat_provider.dart';
import '../Chat/chat_conversation_screen.dart';
import 'Review_screen.dart';

class ViewApplicantsScreen extends StatefulWidget {
  final int jobId;
  
  const ViewApplicantsScreen({
    super.key,
    required this.jobId,
  });

  @override
  State<ViewApplicantsScreen> createState() => _ViewApplicantsScreenState();
}

class _ViewApplicantsScreenState extends State<ViewApplicantsScreen> {
  String _sortBy = 'name'; // name, status, date

  @override
  void initState() {
    super.initState();
    _loadApplicants();
  }

  void _loadApplicants() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final applicantsProvider = Provider.of<JobApplicantsProvider>(context, listen: false);
      
      if (userProvider.user?.token != null) {
        applicantsProvider.setAuthToken(userProvider.user!.token!);
        applicantsProvider.getJobApplicants(widget.jobId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobApplicantsProvider>(
      builder: (context, applicantsProvider, child) {
        List<Applicant> sortedApplicants = List.from(applicantsProvider.applicants);
        
        // Sort applicants based on selected criteria
        switch (_sortBy) {
          case 'name':
            sortedApplicants.sort((a, b) => a.user.name.compareTo(b.user.name));
            break;
          case 'status':
            sortedApplicants.sort((a, b) => a.status.compareTo(b.status));
            break;
          case 'date':
            sortedApplicants.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            break;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Job Applicants',
              style: TextStyle(
                fontFamily: 'HomemadeApple',
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.sort, color: Colors.black),
                onSelected: (String value) {
                  setState(() {
                    _sortBy = value;
                  });
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 'name',
                    child: Text('Sort by Name'),
                  ),
                  const PopupMenuItem(
                    value: 'status',
                    child: Text('Sort by Status'),
                  ),
                  const PopupMenuItem(
                    value: 'date',
                    child: Text('Sort by Date'),
                  ),
                ],
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Error Messages
                if (applicantsProvider.errorMessage != null)
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
                      'Error: ${applicantsProvider.errorMessage}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                

                // Job Info Header
                if (applicantsProvider.jobInfo != null)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
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
                        Row(
                          children: [
                            Text(
                              applicantsProvider.jobInfo!.jobTitle,
                              style: const TextStyle(
                                fontFamily: 'FrederickaTheGreat',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6F8EC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green),
                              ),
                              child: Text(
                                '${applicantsProvider.applicants.length} Applicants',
                                style: const TextStyle(
                                  fontFamily: 'BioRhyme',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildJobInfoChip(Icons.category, applicantsProvider.jobInfo!.category, Colors.blue),
                              const SizedBox(width: 8),
                              _buildJobInfoChip(Icons.info, applicantsProvider.jobInfo!.jobStatus, Colors.orange),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Loading or Applicants List
                if (applicantsProvider.isLoading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (sortedApplicants.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No applicants found for this job.',
                        style: TextStyle(
                          fontFamily: 'LifeSavers',
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: sortedApplicants.length,
                      itemBuilder: (context, index) {
                        final applicant = sortedApplicants[index];
                        return _buildApplicantCard(applicant);
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildJobInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicantCard(Applicant applicant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with profile info
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  applicant.user.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      applicant.user.name,
                      style: const TextStyle(
                        fontFamily: 'HomemadeApple',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      applicant.user.email,
                      style: const TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(applicant.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _getStatusColor(applicant.status)),
                      ),
                      child: Text(
                        _getDisplayStatus(applicant.status),
                        style: TextStyle(
                          fontFamily: 'LifeSavers',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(applicant.status),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Cover Letter
          Text(
            'Cover Letter:',
            style: const TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            applicant.coverLetter,
            style: const TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 14,
              height: 1.4,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 12),

          // Application Date
          Row(
            children: [
              Expanded(
                child: _buildStatChip(
                  icon: Icons.calendar_today,
                  text: 'Applied: ${_formatDate(applicant.createdAt)}',
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatChip(
                  icon: Icons.person,
                  text: 'User ID: ${applicant.userId}',
                  color: Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action Buttons based on status
          if (applicant.status.toLowerCase() == 'in_progress')
            // Show buttons for in_progress status
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showApplicantProfile(applicant);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color(0xFFE3F0FF),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'View Profile',
                      style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'BioRhyme',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _startChatWithApplicant(applicant);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.green, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color(0xFFE8F5E8),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Message',
                      style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'BioRhyme',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showCompleteDialog(applicant.user.name, applicant.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Complete',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'BioRhyme',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else if (applicant.status.toLowerCase() == 'completed')
            // Show only Review and Completed buttons for completed status
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _navigateToReview(applicant);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.amber, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color(0xFFFFF8E1),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Review',
                      style: TextStyle(
                        color: Colors.amber,
                        fontFamily: 'BioRhyme',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Completed',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'BioRhyme',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          else if (applicant.status.toLowerCase() == 'accepted')
            // Show buttons for accepted status
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showApplicantProfile(applicant);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color(0xFFE3F0FF),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'View Profile',
                      style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'BioRhyme',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _startChatWithApplicant(applicant);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.green, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color(0xFFE8F5E8),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Message',
                      style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'BioRhyme',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            // Show buttons for pending status
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showApplicantProfile(applicant);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color(0xFFE3F0FF),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'View Profile',
                      style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'BioRhyme',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showRejectDialog(applicant.user.name, applicant.id);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Reject',
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'BioRhyme',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showApproveDialog(applicant.user.name, applicant.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Approve',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'BioRhyme',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
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

  Widget _buildStatChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showApplicantProfile(Applicant applicant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Profile header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        applicant.user.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            applicant.user.name,
                            style: const TextStyle(
                              fontFamily: 'HomemadeApple',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            applicant.user.email,
                            style: const TextStyle(
                              fontFamily: 'LifeSavers',
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Cover Letter
                const Text(
                  'Cover Letter',
                  style: TextStyle(
                    fontFamily: 'BioRhyme',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  applicant.coverLetter,
                  style: const TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Application Details
                const Text(
                  'Application Details',
                  style: TextStyle(
                    fontFamily: 'BioRhyme',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Applied on: ${_formatDate(applicant.createdAt)}',
                  style: const TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  'Status: ${_getDisplayStatus(applicant.status)}',
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 14,
                    color: _getStatusColor(applicant.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Contact buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.message, color: Colors.blue),
                        label: const Text('Message'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.call, color: Colors.white),
                        label: const Text('Call'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
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
  }

  void _showApproveDialog(String name, int applicantId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Applicant Approved',
                style: TextStyle(
                  fontFamily: 'HomemadeApple',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              
              // Main message
              Text(
                'You\'ve approved this applicant for the job. They\'ve been notified and now need to confirm that they\'ll be there.',
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // What happens next section
              Text(
                'What happens next?',
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              
              _buildBulletPoint('The applicant will review the job details and confirm their availability.'),
              _buildBulletPoint('Once they confirm, the job will be officially scheduled under the in-progress tab.'),
              _buildBulletPoint('You can message them directly in the meantime if needed.'),
              
              const SizedBox(height: 28),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black26),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'Back',
                        style: TextStyle(
                          fontFamily: 'LifeSavers',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _approveAndStartApplication(applicantId);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'Approve & Start',
                        style: TextStyle(
                          fontFamily: 'LifeSavers',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
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
    );
  }

  void _showRejectDialog(String name, int applicantId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Are You Sure You Want to Deny This Client?',
                style: TextStyle(
                  fontFamily: 'HomemadeApple',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Content
              Text(
                'Denying this client will remove their request and they will not be able to book you for this job. This action cannot be undone.',
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Provider.of<JobApplicantsProvider>(context, listen: false)
                            .rejectApplicant(applicantId);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'Yes, Deny Request',
                        style: TextStyle(
                          fontFamily: 'LifeSavers',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'Back',
                        style: TextStyle(
                          fontFamily: 'LifeSavers',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
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
    );
  }

  void _showCompleteDialog(String name, int applicantId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Complete Job',
                style: TextStyle(
                  fontFamily: 'HomemadeApple',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Content
              Text(
                'Are you sure you want to mark this job as completed? This will notify the client that the work has been finished.',
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'LifeSavers',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _completeApplication(applicantId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: Text(
                        'Complete',
                        style: TextStyle(
                          fontFamily: 'LifeSavers',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
    );
  }


  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 16,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue; // Show as pending until user confirms
      case 'confirmed':
        return Colors.green; // Show as confirmed when user accepts
      case 'in_progress':
        return Colors.purple; // Show as in progress when work starts
      case 'completed':
        return Colors.green; // Show as completed when work is finished
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getDisplayStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Pending'; // Show as pending until user confirms
      case 'confirmed':
        return 'Confirmed'; // Show as confirmed when user accepts
      case 'in_progress':
        return 'In Progress'; // Show as in progress when work starts
      case 'completed':
        return 'Completed'; // Show as completed when work is finished
      case 'rejected':
        return 'Rejected';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.toUpperCase();
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  // Approve and start application
  void _approveAndStartApplication(int applicantId) async {
    final applicantsProvider = Provider.of<JobApplicantsProvider>(context, listen: false);
    
    try {
      // First approve the application
      await applicantsProvider.approveApplicant(applicantId);
      
      // Wait a moment for the approval to complete
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Then start the application
      await applicantsProvider.startApplication(applicantId);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application approved and work started successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Complete application
  void _completeApplication(int applicantId) async {
    final applicantsProvider = Provider.of<JobApplicantsProvider>(context, listen: false);
    
    try {
      await applicantsProvider.completeApplication(applicantId);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Job completed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing job: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Start chat with applicant
  void _startChatWithApplicant(Applicant applicant) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    
    if (userProvider.user?.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to start a chat'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Set auth token
      chatProvider.setAuthToken(userProvider.user!.token!);
      
      // Start chat
      await chatProvider.startChat(
        applicationId: applicant.id,
        receiverId: int.parse(applicant.userId),
      );
      
      // Navigate to chat conversation
      if (mounted && chatProvider.currentChat != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatConversationScreen(chat: chatProvider.currentChat!),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting chat: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Navigate to review screen
  void _navigateToReview(Applicant applicant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewScreen(
          applicationId: applicant.id,
          jobTitle: 'Job Application Review', // You can get this from job info if needed
        ),
      ),
    );
  }
}