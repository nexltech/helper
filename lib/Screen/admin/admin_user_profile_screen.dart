import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../models/admin_user_model.dart';
import '../../models/user_profile_model.dart';

class AdminUserProfileScreen extends StatefulWidget {
  final int userId;
  
  const AdminUserProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  State<AdminUserProfileScreen> createState() => _AdminUserProfileScreenState();
}

class _AdminUserProfileScreenState extends State<AdminUserProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load user profile when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfile();
    });
  }

  void _loadUserProfile() {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    adminProvider.clearMessages(); // Clear any existing messages
    adminProvider.getUserProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Consumer<AdminProvider>(
          builder: (context, adminProvider, child) {
            return RefreshIndicator(
              onRefresh: () async {
                adminProvider.clearMessages(); // Clear error messages before refresh
                await adminProvider.getUserProfile(widget.userId);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      
                      // Error Messages
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
                      
                      // Header with Back Button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'User Profile',
                                style: TextStyle(
                                  fontFamily: 'LifeSavers',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // User Profile Content
                      if (adminProvider.isLoading)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (adminProvider.selectedUserProfile != null)
                        _buildUserProfileContent(adminProvider.selectedUserProfile!)
                      else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'No user profile data available',
                              style: TextStyle(
                                fontFamily: 'LifeSavers',
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      
                      const SizedBox(height: 80), // Spacer for navbar
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserProfileContent(UserProfile userProfile) {
    final user = userProfile.user;
    final hireHelp = userProfile.hireHelp;
    final offerHelp = userProfile.offerHelp;
    final bothHelp = userProfile.bothHelp;

    return Column(
      children: [
        // Basic User Information
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
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
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: _getStatusColor(user.status).withOpacity(0.1),
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                      style: TextStyle(
                        fontFamily: 'LifeSavers',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: _getStatusColor(user.status),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontFamily: 'LifeSavers',
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: const TextStyle(
                            fontFamily: 'LifeSavers',
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(user.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _getStatusColor(user.status)),
                          ),
                          child: Text(
                            user.status.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'LifeSavers',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(user.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildInfoRow('Role', user.role),
              _buildInfoRow('User ID', user.id.toString()),
              _buildInfoRow('Email Verified', user.emailVerifiedAt != null ? 'Yes' : 'No'),
              _buildInfoRow('Created', _formatDate(user.createdAt)),
              _buildInfoRow('Last Updated', _formatDate(user.updatedAt)),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Hire Help Information
        if (hireHelp != null) ...[
          _buildRoleSection('Hire Help Information', hireHelp, Colors.blue),
          const SizedBox(height: 16),
        ],
        
        // Offer Help Information
        if (offerHelp != null) ...[
          _buildRoleSection('Offer Help Information', offerHelp, Colors.green),
          const SizedBox(height: 16),
        ],
        
        // Both Help Information
        if (bothHelp != null) ...[
          _buildRoleSection('Both Help Information', bothHelp, Colors.purple),
          const SizedBox(height: 16),
        ],
        
        // Action Buttons
        _buildActionButtons(user),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontFamily: 'LifeSavers',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSection(String title, Map<String, dynamic> data, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.person,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...data.entries.map((entry) => _buildInfoRow(
            entry.key.replaceAll('_', ' ').toUpperCase(),
            entry.value?.toString() ?? 'N/A',
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AdminUser user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showCommentDialog(context, user.id),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Add Comment',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showStatusActionDialog(context, user),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: user.status == 'active' ? Colors.red : Colors.orange,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    user.status == 'active' ? 'Suspend' : 'Reactivate',
                    style: TextStyle(
                      color: user.status == 'active' ? Colors.red : Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _showCommentDialog(BuildContext context, int userId) {
    final TextEditingController commentController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add Comment',
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: 'Comment',
                  hintText: 'Enter your comment...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                final adminProvider = Provider.of<AdminProvider>(context, listen: false);
                adminProvider.addCommentToUser(
                  userId: userId,
                  comment: commentController.text,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Add Comment',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showStatusActionDialog(BuildContext context, AdminUser user) {
    final TextEditingController commentController = TextEditingController();
    final isSuspend = user.status == 'active';
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isSuspend ? 'Suspend User' : 'Reactivate User',
            style: const TextStyle(
              fontFamily: 'LifeSavers',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isSuspend 
                ? 'Are you sure you want to suspend this user?' 
                : 'Are you sure you want to reactivate this user?'),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  labelText: 'Reason',
                  hintText: isSuspend 
                    ? 'Enter reason for suspension...' 
                    : 'Enter reason for reactivation...',
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                final adminProvider = Provider.of<AdminProvider>(context, listen: false);
                if (isSuspend) {
                  adminProvider.suspendUser(
                    userId: user.id,
                    comment: commentController.text,
                  );
                } else {
                  adminProvider.reactivateUser(
                    userId: user.id,
                    comment: commentController.text,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSuspend ? Colors.red : Colors.orange,
              ),
              child: Text(
                isSuspend ? 'Suspend' : 'Reactivate',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
