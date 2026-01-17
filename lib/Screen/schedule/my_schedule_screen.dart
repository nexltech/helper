import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/my_applications_provider.dart';
import '../../providers/crud_job_provider.dart';
import '../../models/my_application_model.dart';
import '../../models/job_model.dart';
import '../jobBoarding/navbar.dart';

class MyScheduleScreen extends StatefulWidget {
  const MyScheduleScreen({super.key});

  @override
  State<MyScheduleScreen> createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends State<MyScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  String _viewMode = 'calendar'; // 'calendar' or 'list'

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final applicationsProvider = Provider.of<MyApplicationsProvider>(context, listen: false);
      final jobProvider = Provider.of<CrudJobProvider>(context, listen: false);
      
      if (userProvider.user?.token != null) {
        applicationsProvider.setAuthToken(userProvider.user!.token!);
        jobProvider.setAuthToken(userProvider.user!.token!);
        applicationsProvider.getMyApplications();
        jobProvider.getActiveJobs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // View Mode Toggle
            _buildViewModeToggle(),
            
            // Content
            Expanded(
              child: _viewMode == 'calendar'
                  ? _buildCalendarView()
                  : _buildListView(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'My Schedule',
              style: TextStyle(
                fontFamily: 'HomemadeApple',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewModeToggle() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
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
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _viewMode = 'calendar'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _viewMode == 'calendar' ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: _viewMode == 'calendar' ? Colors.white : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Calendar',
                      style: TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _viewMode == 'calendar' ? Colors.white : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _viewMode = 'list'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _viewMode == 'list' ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.list,
                      color: _viewMode == 'list' ? Colors.white : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'List',
                      style: TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _viewMode == 'list' ? Colors.white : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return Consumer2<MyApplicationsProvider, CrudJobProvider>(
      builder: (context, applicationsProvider, jobProvider, child) {
        final scheduledItems = _getScheduledItems(applicationsProvider, jobProvider);
        
        return Column(
          children: [
            // Calendar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
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
                children: [
                  // Month Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {
                          setState(() {
                            _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
                          });
                        },
                      ),
                      Text(
                        '${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                        style: const TextStyle(
                          fontFamily: 'LifeSavers',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          setState(() {
                            _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Calendar Grid
                  _buildCalendarGrid(scheduledItems),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Selected Date Jobs
            Expanded(
              child: _buildSelectedDateJobs(scheduledItems),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCalendarGrid(List<ScheduledItem> scheduledItems) {
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    
    // Get days with scheduled items
    final daysWithItems = scheduledItems.map((item) {
      try {
        final date = DateTime.parse(item.dateTime);
        return DateTime(date.year, date.month, date.day);
      } catch (e) {
        return null;
      }
    }).whereType<DateTime>().toSet();

    return Column(
      children: [
        // Weekday headers
        Row(
          children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
              .map((day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontFamily: 'LifeSavers',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        // Calendar days
        ...List.generate(6, (weekIndex) {
          return Row(
            children: List.generate(7, (dayIndex) {
              final dayNumber = weekIndex * 7 + dayIndex - firstWeekday + 2;
              if (dayNumber < 1 || dayNumber > lastDayOfMonth.day) {
                return const Expanded(child: SizedBox());
              }
              
              final dayDate = DateTime(_selectedDate.year, _selectedDate.month, dayNumber);
              final hasItems = daysWithItems.contains(dayDate);
              final isToday = dayDate.year == DateTime.now().year &&
                  dayDate.month == DateTime.now().month &&
                  dayDate.day == DateTime.now().day;
              final isSelected = dayDate.year == _selectedDate.year &&
                  dayDate.month == _selectedDate.month &&
                  dayDate.day == _selectedDate.day;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = dayDate;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue
                          : (isToday ? Colors.blue.shade50 : Colors.transparent),
                      borderRadius: BorderRadius.circular(8),
                      border: isToday
                          ? Border.all(color: Colors.blue, width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$dayNumber',
                          style: TextStyle(
                            fontFamily: 'LifeSavers',
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        if (hasItems)
                          Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.blue,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  Widget _buildSelectedDateJobs(List<ScheduledItem> scheduledItems) {
    final selectedDateItems = scheduledItems.where((item) {
      try {
        final itemDate = DateTime.parse(item.dateTime);
        return itemDate.year == _selectedDate.year &&
            itemDate.month == _selectedDate.month &&
            itemDate.day == _selectedDate.day;
      } catch (e) {
        return false;
      }
    }).toList();

    if (selectedDateItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No jobs scheduled for this date',
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: selectedDateItems.length,
      itemBuilder: (context, index) {
        return _buildScheduleCard(selectedDateItems[index]);
      },
    );
  }

  Widget _buildListView() {
    return Consumer2<MyApplicationsProvider, CrudJobProvider>(
      builder: (context, applicationsProvider, jobProvider, child) {
        final scheduledItems = _getScheduledItems(applicationsProvider, jobProvider);
        
        // Sort by date
        scheduledItems.sort((a, b) {
          try {
            final dateA = DateTime.parse(a.dateTime);
            final dateB = DateTime.parse(b.dateTime);
            return dateA.compareTo(dateB);
          } catch (e) {
            return 0;
          }
        });

        if (scheduledItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No scheduled jobs',
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await applicationsProvider.getMyApplications();
            await jobProvider.getActiveJobs();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: scheduledItems.length,
            itemBuilder: (context, index) {
              return _buildScheduleCard(scheduledItems[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildScheduleCard(ScheduledItem item) {
    DateTime? jobDate;
    String timeStr = '';
    
    try {
      jobDate = DateTime.parse(item.dateTime);
      timeStr = '${jobDate.hour.toString().padLeft(2, '0')}:${jobDate.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      timeStr = 'Time TBD';
    }

    return Container(
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getStatusColor(item.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.work,
                  color: _getStatusColor(item.status),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          timeStr,
                          style: TextStyle(
                            fontFamily: 'LifeSavers',
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.address,
                            style: TextStyle(
                              fontFamily: 'LifeSavers',
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(item.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.status.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(item.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.account_balance_wallet, size: 16, color: Colors.green),
              const SizedBox(width: 4),
              Text(
                '\$${item.payment}',
                style: const TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const Spacer(),
              if (jobDate != null)
                Text(
                  _formatDate(jobDate),
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  List<ScheduledItem> _getScheduledItems(
    MyApplicationsProvider applicationsProvider,
    CrudJobProvider jobProvider,
  ) {
    final items = <ScheduledItem>[];

    // Add accepted applications (jobs user applied to and got accepted)
    for (var application in applicationsProvider.acceptedApplications) {
      items.add(ScheduledItem(
        id: application.id,
        title: application.jobPost.jobTitle,
        dateTime: application.jobPost.dateTime,
        address: application.jobPost.address,
        payment: application.jobPost.payment,
        status: application.status,
        type: 'application',
      ));
    }

    // Add user's posted jobs
    for (var job in jobProvider.jobs) {
      items.add(ScheduledItem(
        id: job.id,
        title: job.jobTitle,
        dateTime: job.dateTime,
        address: job.address,
        payment: job.payment,
        status: job.status,
        type: 'job',
      ));
    }

    return items;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      case 'active':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class ScheduledItem {
  final int id;
  final String title;
  final String dateTime;
  final String address;
  final String payment;
  final String status;
  final String type; // 'application' or 'job'

  ScheduledItem({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.address,
    required this.payment,
    required this.status,
    required this.type,
  });
}

