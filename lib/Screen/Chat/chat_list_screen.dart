import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/chat_model.dart';
import 'chat_conversation_screen.dart';
import '../jobBoarding/navbar.dart';
import '../jobBoarding/job_board_main_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> with WidgetsBindingObserver {
  Timer? _chatPollTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadChats();
    _startChatPolling();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _chatPollTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // App came to foreground - refresh chats immediately
      _loadChats();
      _startChatPolling();
    } else if (state == AppLifecycleState.paused) {
      // App went to background - stop polling to save battery
      _chatPollTimer?.cancel();
    }
  }

  void _loadChats() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      
      if (userProvider.user?.token != null) {
        chatProvider.setAuthToken(userProvider.user!.token!);
        chatProvider.getAllChats(showLoading: true);
      }
    });
  }

  void _startChatPolling() {
    // Poll for new chats every 5 seconds when screen is active
    _chatPollTimer?.cancel();
    _chatPollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        chatProvider.getAllChats(showLoading: false).catchError((error) {
          // Silently handle errors during polling to prevent crashes
          print('Error polling chats: $error');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      resizeToAvoidBottomInset: true, // Allow screen to resize when keyboard appears
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Messages',
          style: TextStyle(
            fontFamily: 'HomemadeApple',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              Provider.of<ChatProvider>(context, listen: false).refreshAllData();
            },
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return Column(
            children: [
              // Error Messages
              if (chatProvider.errorMessage != null && chatProvider.errorMessage!.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Error: ${chatProvider.errorMessage}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red, size: 18),
                        onPressed: () {
                          chatProvider.clearMessages();
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              

              // Chats List
              Expanded(
                child: chatProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : chatProvider.chats.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No conversations yet',
                                  style: TextStyle(
                                    fontFamily: 'LifeSavers',
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Start a conversation by applying to jobs',
                                  style: TextStyle(
                                    fontFamily: 'LifeSavers',
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              await chatProvider.refreshAllData();
                            },
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: chatProvider.chats.length,
                              itemBuilder: (context, index) {
                                final chat = chatProvider.chats[index];
                                return _buildChatCard(chat, chatProvider);
                              },
                            ),
                          ),
              ),
            ],
          );
        },
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const JobBoardMainScreen(),
              ),
            );
          },
          backgroundColor: const Color(0xFFDDF8E5),
          elevation: 0,
          child: Image.asset(
            'assets/Icons/Plus Math.png',
            width: 48,
            height: 48,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.add, color: Colors.green, size: 48);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChatCard(Chat chat, ChatProvider chatProvider) {
    final currentUser = Provider.of<UserProvider>(context, listen: false).user;
    final otherUser = chat.sender.id == currentUser?.id ? chat.receiver : chat.sender;
    final lastMessage = chatProvider.getLastMessage(chat.id);
    final unreadCount = chatProvider.getUnreadMessageCount(chat.id);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.blue.shade100,
          child: Text(
            otherUser.name.isNotEmpty ? otherUser.name[0].toUpperCase() : 'U',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                otherUser.name,
                style: const TextStyle(
                  fontFamily: 'HomemadeApple',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            if (unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              chat.application.jobPost.jobTitle,
              style: const TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 14,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            if (lastMessage != null)
              Text(
                lastMessage.message,
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 14,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            else
              const Text(
                'No messages yet',
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 14,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            const SizedBox(height: 4),
            if (lastMessage != null)
              Text(
                chatProvider.formatMessageTime(lastMessage.createdAt),
                style: const TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatConversationScreen(chat: chat),
            ),
          );
        },
      ),
    );
  }
}
