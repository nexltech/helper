import 'package:flutter/material.dart';
import '../../models/notification_model.dart';
import '../jobBoarding/navbar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> _notifications = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      _isLoading = true;
    });

    // TODO: Replace with actual API call
    // For now, using mock data
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _notifications = _getMockNotifications();
        _isLoading = false;
      });
    });
  }

  List<NotificationItem> _getMockNotifications() {
    final now = DateTime.now();
    return [
      NotificationItem(
        id: 1,
        title: 'New Application Received',
        message: 'John Doe applied for your job "Need a Plumber"',
        type: 'application',
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 5)).toIso8601String(),
        data: {'jobId': 1, 'applicationId': 1},
      ),
      NotificationItem(
        id: 2,
        title: 'Application Accepted',
        message: 'Your application for "Garden Maintenance" has been accepted!',
        type: 'application',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 2)).toIso8601String(),
        data: {'jobId': 2, 'applicationId': 2},
      ),
      NotificationItem(
        id: 3,
        title: 'New Message',
        message: 'You have a new message from Sarah',
        type: 'message',
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 5)).toIso8601String(),
        data: {'chatId': 1},
      ),
      NotificationItem(
        id: 4,
        title: 'Review Reminder',
        message: 'Don\'t forget to review your completed job',
        type: 'review',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)).toIso8601String(),
        data: {'jobId': 3},
      ),
      NotificationItem(
        id: 5,
        title: 'Job Posted Successfully',
        message: 'Your job "House Cleaning" has been posted',
        type: 'job',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 2)).toIso8601String(),
        data: {'jobId': 4},
      ),
      NotificationItem(
        id: 6,
        title: 'System Update',
        message: 'New features are now available in the app',
        type: 'system',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 3)).toIso8601String(),
      ),
    ];
  }

  void _markAsRead(NotificationItem notification) {
    setState(() {
      _notifications = _notifications.map((n) {
        if (n.id == notification.id) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();
    });
    // TODO: Call API to mark as read
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    });
    // TODO: Call API to mark all as read
  }

  void _deleteNotification(NotificationItem notification) {
    setState(() {
      _notifications.removeWhere((n) => n.id == notification.id);
    });
    // TODO: Call API to delete notification
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Notifications List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _notifications.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: () async {
                            _loadNotifications();
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: _notifications.length,
                            itemBuilder: (context, index) {
                              return _buildNotificationCard(_notifications[index]);
                            },
                          ),
                        ),
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
              'Notifications',
              style: TextStyle(
                fontFamily: 'HomemadeApple',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          if (_unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(width: 8),
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(Colors.grey[300]!, BlendMode.modulate),
            child: Image.asset(
              'assets/Icons/Alarm.png',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.notifications_none,
                  size: 80,
                  color: Colors.grey[300],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'ll see notifications here when you receive them',
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    final icon = _getNotificationIcon(notification.type);
    final iconColor = _getNotificationColor(notification.type);

    return Dismissible(
      key: Key(notification.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        _deleteNotification(notification);
      },
      child: GestureDetector(
        onTap: () {
          if (!notification.isRead) {
            _markAsRead(notification);
          }
          _handleNotificationTap(notification);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: notification.isRead ? Colors.grey[200]! : Colors.blue.shade200,
              width: notification.isRead ? 1 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontFamily: 'LifeSavers',
                              fontSize: 16,
                              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTime(notification.createdAt),
                      style: TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'job':
        return Icons.work;
      case 'application':
        return Icons.person_add;
      case 'message':
        return Icons.message;
      case 'review':
        return Icons.star;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'job':
        return Colors.blue;
      case 'application':
        return Colors.green;
      case 'message':
        return Colors.purple;
      case 'review':
        return Colors.amber;
      case 'system':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  String _formatTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }

  void _handleNotificationTap(NotificationItem notification) {
    // TODO: Navigate based on notification type
    switch (notification.type) {
      case 'job':
        // Navigate to job details
        if (notification.data?['jobId'] != null) {
          // Navigator.push(...);
        }
        break;
      case 'application':
        // Navigate to application details
        if (notification.data?['applicationId'] != null) {
          // Navigator.push(...);
        }
        break;
      case 'message':
        // Navigate to chat
        if (notification.data?['chatId'] != null) {
          // Navigator.push(...);
        }
        break;
      case 'review':
        // Navigate to review screen
        if (notification.data?['jobId'] != null) {
          // Navigator.push(...);
        }
        break;
      default:
        break;
    }
  }
}

