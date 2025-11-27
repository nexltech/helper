import 'package:flutter/material.dart';
import 'package:job/Screen/jobBoarding/navbar.dart';

class AdminNotificationsScreen extends StatefulWidget {
  const AdminNotificationsScreen({super.key});

  @override
  State<AdminNotificationsScreen> createState() => _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  final Map<String, bool> _notificationSettings = {
    'New Job Posted': true,
    'Application Updates': true,
    'Messages': false,
    'Reminders': false,
    'Review Reminder': false,
    'System Alerts': true,
  };

  @override
  Widget build(BuildContext context) {
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
                // Header
                _buildHeader(),
                const SizedBox(height: 24),
                // Notifications List
                _buildNotificationsList(),
                const SizedBox(height: 24),
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
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Admin Quick Action - Coming Soon'),
                backgroundColor: Colors.green,
              ),
            );
          },
          backgroundColor: Colors.white,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.green, size: 40),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 8),
        const Text(
          'Notifications',
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

  Widget _buildNotificationsList() {
    return Container(
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
        children: [
          _buildNotificationItem(
            'New Job Posted',
            'Applicant confirmed job that was posted.',
            'New Job Posted',
            true,
          ),
          _buildNotificationItem(
            'New Job Posted',
            'Applicant denied job that was posted.',
            'New Job Posted',
            false,
          ),
          _buildNotificationItem(
            'Application Updates',
            'Application Approved / Denied.',
            'Application Updates',
            true,
          ),
          _buildNotificationItem(
            'Messages',
            'New Message received.',
            'Messages',
            false,
          ),
          _buildNotificationItem(
            'Reminders',
            'Upcoming Job Start Reminder',
            'Reminders',
            false,
          ),
          _buildNotificationItem(
            'Reminders',
            'Review Reminder (post-job)',
            'Review Reminder',
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String subtitle,
    String key,
    bool isEnabled,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _notificationSettings[key] ?? isEnabled,
            onChanged: (value) {
              setState(() {
                _notificationSettings[key] = value;
              });
            },
            activeColor: Colors.green,
            inactiveThumbColor: Colors.grey[300],
            inactiveTrackColor: Colors.grey[200],
          ),
        ],
      ),
    );
  }
}
