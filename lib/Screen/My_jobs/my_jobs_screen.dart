import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:job/Screen/jobBoarding/navbar.dart';
import 'package:job/Screen/My_jobs/view_applicants_screen.dart';
import 'package:job/Screen/My_jobs/job_post_screen.dart';
import 'package:job/Screen/My_jobs/cancel_job_dialog.dart';
import 'package:job/Screen/My_jobs/edit_job_screen.dart';
import 'package:job/Screen/My_jobs/job_details_screen.dart';
import '../../providers/crud_job_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/my_applications_provider.dart';
import '../../models/job_model.dart';
import '../../models/my_application_model.dart';

class MyJobsScreen extends StatefulWidget {
  const MyJobsScreen({super.key});

  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _topTabIndex = 0; // 0 = My Jobs, 1 = My Applications
  bool showApplicantCard = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Load jobs when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadJobs();
    });
  }

  void _loadJobs() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final jobProvider = Provider.of<CrudJobProvider>(context, listen: false);
    final applicationsProvider = Provider.of<MyApplicationsProvider>(context, listen: false);
    
    // Set auth token and fetch jobs and applications
    if (userProvider.user?.token != null) {
      jobProvider.setAuthToken(userProvider.user!.token!);
      applicationsProvider.setAuthToken(userProvider.user!.token!);
      jobProvider.getAllJobs();
      applicationsProvider.getMyApplications();
    }
  }

  void _deleteJob(int jobId) {
    // Find the job to get its title
    final jobProvider = Provider.of<CrudJobProvider>(context, listen: false);
    final job = jobProvider.jobs.firstWhere((j) => j.id == jobId);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CancelJobDialog(
          jobTitle: job.jobTitle,
          onConfirm: () async {
            await jobProvider.deleteJobPost(jobId);
          },
        );
      },
    );
  }

  void _editJob(JobPost job) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditJobScreen(job: job),
      ),
    );
  }

  void _viewJobDetails(JobPost job) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobDetailsScreen(job: job),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'in_progress':
        return Colors.blue;
      case 'completed':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CrudJobProvider>(
      builder: (context, jobProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await jobProvider.refreshAllData();
                await Provider.of<MyApplicationsProvider>(context, listen: false).refreshAllData();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                      Container(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 66,
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
                            fontSize: 50,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Activity',
                              style: const TextStyle(
                                fontFamily: 'HomemadeApple',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/Icons/Bell.png',
                            width: 88,
                            height: 88,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Top Tabs
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: Colors.black,
                        width: 1), // Add border around the whole container
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _topTabIndex = 0;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: _topTabIndex == 0
                                ? const Color(0xFFF0F0F0)
                                : Colors.white, // Slightly darker for selected
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                              side: BorderSide.none,
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'My Jobs',
                            style: TextStyle(
                              fontFamily: 'bioRhyme',
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                              color: _topTabIndex == 0
                                  ? Colors.black
                                  : Colors.black26,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _topTabIndex = 1;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: _topTabIndex == 1
                                ? const Color(0xFFF0F0F0)
                                : Colors.white, // Slightly darker for selected
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                              side: BorderSide.none,
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'My Applications',
                            style: TextStyle(
                              fontFamily: 'LifeSavers',
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: _topTabIndex == 1
                                  ? Colors.black
                                  : Colors.black26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Status Tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(3, (index) {
                      final tabTitles = [
                        'Active',
                        'In-Progress',
                        'Completed'
                      ];
                      final isSelected = _tabController.index == index;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _tabController.index = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFF0F0F0)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border:
                                  Border.all(color: Colors.black12, width: 1),
                            ),
                            child: Row(
                              children: [
                                if (index == 0)
                                  Icon(Icons.radio_button_checked,
                                      size: 16,
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.black38),
                                if (index == 0) const SizedBox(width: 4),
                                Text(
                                  tabTitles[index],
                                  style: TextStyle(
                                    fontFamily: 'BioRhyme',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.black38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 12),
                // Content for each tab - Make it expandable and scrollable
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _topTabIndex == 0
                          ? _buildMyJobsActiveCard()
                          : _buildMyApplicationsActiveCard(),
                      _topTabIndex == 0
                          ? _buildMyJobsInProgressCard()
                          : _buildMyApplicationsActiveCard(),
                      _topTabIndex == 0
                          ? _buildMyJobsCompletedCard()
                          : _buildMyApplicationsActiveCard(),
                    ],
                  ),
                ),
                      ],
                    ),
              ),
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
                  offset: Offset(0, 4),
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
      },
    );
  }

  Widget _buildMyJobsActiveCard() {
    return Consumer<CrudJobProvider>(
      builder: (context, jobProvider, child) {
        if (jobProvider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Filter jobs based on status
        final activeJobs = jobProvider.jobs.where((job) => 
          job.status.toLowerCase() == 'active'
        ).toList();

        if (activeJobs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No active jobs found. Create your first job!',
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: activeJobs.length,
          itemBuilder: (context, index) {
            return _buildJobCard(activeJobs[index]);
          },
        );
      },
    );
  }

  Widget _buildJobCard(JobPost job) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blueGrey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.blue[100],
                child: Text(
                  job.user?.name.isNotEmpty == true 
                    ? job.user!.name[0].toUpperCase() 
                    : (job.jobTitle.isNotEmpty ? job.jobTitle[0].toUpperCase() : 'J'),
                  style: const TextStyle(
                    fontFamily: 'FrederickaTheGreat',
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  job.jobTitle,
                  style: const TextStyle(
                    fontFamily: 'FrederickaTheGreat',
                    fontSize: 26,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Category: ${job.category.name}',
            style: const TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(job.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _getStatusColor(job.status), width: 1),
            ),
            child: Text(
              job.status.toUpperCase(),
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: _getStatusColor(job.status),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Image.asset('assets/Icons/dollar.png', width: 16, height: 16),
                const SizedBox(width: 2),
                Text(
                  '\$${job.payment}',
                  style: const TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset('assets/Icons/Calender.png', width: 16, height: 16),
                const SizedBox(width: 2),
                Text(
                  job.dateTime.split(' ')[0], // Date part
                  style: const TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset('assets/Icons/Location.png', width: 16, height: 16),
                const SizedBox(width: 2),
                Text(
                  job.address,
                  style: const TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset('assets/Icons/HomeSerices.png', width: 16, height: 16),
                const SizedBox(width: 2),
                Text(
                  job.category.name,
                  style: const TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewApplicantsScreen(jobId: job.id),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.blue, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: const Color(0xFFE3F0FF),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text(
                'View Applicants',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'bioRhyme',
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _deleteJob(job.id),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'bioRhyme',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _editJob(job),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.orange, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'bioRhyme',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _viewJobDetails(job),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text(
                    'Details',
                    style: TextStyle(
                      fontFamily: 'bioRhyme',
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
    );
  }

  Widget _buildMyJobsInProgressCard() {
    return Consumer<CrudJobProvider>(
      builder: (context, jobProvider, child) {
        if (jobProvider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Filter jobs based on in-progress status
        final inProgressJobs = jobProvider.jobs.where((job) => 
          job.status.toLowerCase() == 'in_progress'
        ).toList();

        if (inProgressJobs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No in-progress jobs found.',
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: inProgressJobs.length,
          itemBuilder: (context, index) {
            return _buildJobCard(inProgressJobs[index]);
          },
        );
      },
    );
  }

  Widget _buildMyJobsCompletedCard() {
    return Consumer<CrudJobProvider>(
      builder: (context, jobProvider, child) {
        if (jobProvider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Filter jobs based on completed status
        final completedJobs = jobProvider.jobs.where((job) => 
          job.status.toLowerCase() == 'completed'
        ).toList();

        if (completedJobs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No completed jobs found.',
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: completedJobs.length,
          itemBuilder: (context, index) {
            return _buildJobCard(completedJobs[index]);
          },
        );
      },
    );
  }




  Widget _buildMyApplicationsActiveCard() {
    return Consumer<MyApplicationsProvider>(
      builder: (context, applicationsProvider, child) {
        if (applicationsProvider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Filter applications based on status
        final pendingApplications = applicationsProvider.pendingApplications;
        final acceptedApplications = applicationsProvider.acceptedApplications;
        final rejectedApplications = applicationsProvider.rejectedApplications;

        if (pendingApplications.isEmpty && acceptedApplications.isEmpty && rejectedApplications.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No applications found. Apply to some jobs!',
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          itemCount: pendingApplications.length + acceptedApplications.length + rejectedApplications.length,
          itemBuilder: (context, index) {
            MyApplication application;
            if (index < pendingApplications.length) {
              application = pendingApplications[index];
            } else if (index < pendingApplications.length + acceptedApplications.length) {
              application = acceptedApplications[index - pendingApplications.length];
            } else {
              application = rejectedApplications[index - pendingApplications.length - acceptedApplications.length];
            }

            return _buildRealApplicationCard(application);
          },
        );
      },
    );
  }

  Widget _buildRealApplicationCard(MyApplication application) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blueGrey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.blue[100],
                child: Text(
                  application.jobPost.jobTitle.isNotEmpty 
                    ? application.jobPost.jobTitle[0].toUpperCase() 
                    : 'J',
                  style: const TextStyle(
                    fontFamily: 'FrederickaTheGreat',
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.jobPost.jobTitle,
                      style: const TextStyle(
                        fontFamily: 'HomemadeApple',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Category: ${_getCategoryName(application.jobPost.jobCategoryId)}',
                      style: const TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getApplicationStatusColor(application.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getApplicationStatusColor(application.status)),
                ),
                child: Text(
                  _getApplicationStatusText(application.status),
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _getApplicationStatusColor(application.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildApplicationInfoChip(
                  icon: Icons.account_balance_wallet,
                  text: '\$${application.jobPost.payment}',
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildApplicationInfoChip(
                  icon: Icons.calendar_today,
                  text: _formatApplicationDate(application.jobPost.dateTime),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildApplicationInfoChip(
                  icon: Icons.location_on,
                  text: application.jobPost.address,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Cover Letter:',
            style: const TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            application.coverLetter,
            style: const TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 12,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (application.status.toLowerCase() == 'pending') ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Show application details
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text(
                      'Details',
                      style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'BioRhyme',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ] else if (application.status.toLowerCase() == 'accepted') ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Cancel application
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'BioRhyme',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Message hirer
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.green, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color(0xFFE8F5E8),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text(
                      'Message',
                      style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'BioRhyme',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ] else if (application.status.toLowerCase() == 'rejected') ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // View details
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text(
                      'Details',
                      style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'BioRhyme',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationInfoChip({
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

  String _getCategoryName(String categoryId) {
    switch (categoryId) {
      case '1':
        return 'Home Services';
      case '2':
        return 'Family & Personal Care';
      case '3':
        return 'Lifestyle & Events';
      case '4':
        return 'Business Support';
      case '5':
        return 'Vehicle Services';
      case '6':
        return 'Other';
      default:
        return 'Unknown';
    }
  }

  Color _getApplicationStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getApplicationStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Pending'; // Show as pending until user confirms
      case 'rejected':
        return 'Rejected';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.toUpperCase();
    }
  }

  String _formatApplicationDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
