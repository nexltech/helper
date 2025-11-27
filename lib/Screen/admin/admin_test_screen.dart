import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';

class AdminTestScreen extends StatefulWidget {
  const AdminTestScreen({super.key});

  @override
  State<AdminTestScreen> createState() => _AdminTestScreenState();
}

class _AdminTestScreenState extends State<AdminTestScreen> {
  @override
  void initState() {
    super.initState();
    // Set auth token and test API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _testAPIs();
    });
  }

  void _testAPIs() {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    adminProvider.setAuthToken('39|rzQoPz7qgrgEWKPVh54Qvwea1gYsn6StelJorpQ80f1714e3');
    adminProvider.fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin API Test'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<AdminProvider>(
        builder: (context, adminProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Messages
                if (adminProvider.errorMessage != null)
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
                      'Error: ${adminProvider.errorMessage}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                

                // Loading Indicator
                if (adminProvider.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),

                // Test Buttons
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => adminProvider.fetchAllUsers(),
                      child: const Text('Fetch All Users'),
                    ),
                    ElevatedButton(
                      onPressed: () => adminProvider.fetchUsersByStatus('pending'),
                      child: const Text('Fetch Pending'),
                    ),
                    ElevatedButton(
                      onPressed: () => adminProvider.fetchUsersByStatus('active'),
                      child: const Text('Fetch Active'),
                    ),
                    ElevatedButton(
                      onPressed: () => adminProvider.fetchUsersByStatus('suspended'),
                      child: const Text('Fetch Suspended'),
                    ),
                    ElevatedButton(
                      onPressed: () => adminProvider.clearAllData(),
                      child: const Text('Clear Data'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // User Statistics
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'User Statistics',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Pending: ${adminProvider.pendingUsers.length}'),
                      Text('Active: ${adminProvider.activeUsers.length}'),
                      Text('Suspended: ${adminProvider.suspendedUsers.length}'),
                      Text('Total: ${adminProvider.pendingUsers.length + adminProvider.activeUsers.length + adminProvider.suspendedUsers.length}'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // User Lists
                Expanded(
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        const TabBar(
                          tabs: [
                            Tab(text: 'Pending'),
                            Tab(text: 'Active'),
                            Tab(text: 'Suspended'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _buildUserList(adminProvider.pendingUsers, 'Pending'),
                              _buildUserList(adminProvider.activeUsers, 'Active'),
                              _buildUserList(adminProvider.suspendedUsers, 'Suspended'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserList(List users, String title) {
    if (users.isEmpty) {
      return Center(
        child: Text(
          'No $title users',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(user.status),
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(user.name),
            subtitle: Text(user.email),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  user.role,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  user.status,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getStatusColor(user.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Selected: ${user.name} (${user.status})'),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'active':
        return Colors.green;
      case 'suspended':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
