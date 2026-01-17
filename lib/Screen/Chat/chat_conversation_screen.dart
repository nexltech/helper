import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/chat_model.dart';

class ChatConversationScreen extends StatefulWidget {
  final Chat chat;
  
  const ChatConversationScreen({
    super.key,
    required this.chat,
  });

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _messagePollTimer;
  int _previousMessageCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadChatMessages();
    _startMessagePolling();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messagePollTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // App came to foreground - refresh messages immediately
      _loadChatMessages();
      _startMessagePolling();
    } else if (state == AppLifecycleState.paused) {
      // App went to background - stop polling to save battery
      _messagePollTimer?.cancel();
    }
  }

  void _loadChatMessages() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      
      if (userProvider.user?.token != null) {
        chatProvider.setAuthToken(userProvider.user!.token!);
        chatProvider.setCurrentChat(widget.chat);
        chatProvider.getChatMessages(widget.chat.id, showLoading: true).then((_) {
          if (!mounted) return;
          // Auto-scroll to bottom after messages load
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              final currentCount = chatProvider.currentChatMessages.length;
              if (currentCount > _previousMessageCount && _previousMessageCount > 0) {
                _scrollToBottom();
              } else if (_previousMessageCount == 0) {
                // First load - scroll to bottom
                _scrollToBottom();
              }
              _previousMessageCount = currentCount;
            }
          });
        }).catchError((error) {
          print('Error loading messages: $error');
        });
      }
    });
  }

  void _startMessagePolling() {
    // Poll for new messages every 3 seconds when screen is active
    _messagePollTimer?.cancel();
    _messagePollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) {
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        final currentCount = chatProvider.currentChatMessages.length;
        
        chatProvider.getChatMessages(widget.chat.id, showLoading: false).then((_) {
          if (!mounted) return;
          // Auto-scroll if new messages arrived
          final newCount = chatProvider.currentChatMessages.length;
          if (newCount > currentCount) {
            // Use SchedulerBinding to ensure scroll happens after build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _scrollToBottom();
              }
            });
          }
        }).catchError((error) {
          // Silently handle errors during polling to prevent crashes
          print('Error polling messages: $error');
        });
      }
    });
  }


  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      // Use jumpTo for immediate scroll, or animateTo for smooth scroll
      final maxScroll = _scrollController.position.maxScrollExtent;
      if (maxScroll > 0) {
        _scrollController.animateTo(
          maxScroll,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } else {
      // If scroll controller doesn't have clients yet, wait and try again
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.hasClients) {
          final maxScroll = _scrollController.position.maxScrollExtent;
          if (maxScroll > 0) {
            _scrollController.animateTo(
              maxScroll,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        }
      });
    }
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context, listen: false).user;
    final otherUser = widget.chat.sender.id == currentUser?.id 
        ? widget.chat.receiver 
        : widget.chat.sender;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      resizeToAvoidBottomInset: true, // Allow screen to resize when keyboard appears
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                otherUser.name.isNotEmpty ? otherUser.name[0].toUpperCase() : 'U',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUser.name,
                    style: const TextStyle(
                      fontFamily: 'HomemadeApple',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.chat.application.jobPost.jobTitle,
                    style: const TextStyle(
                      fontFamily: 'LifeSavers',
                      fontSize: 12,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              _showChatOptions(context, otherUser);
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: _dismissKeyboard, // Dismiss keyboard when tapping outside
        behavior: HitTestBehavior.opaque,
        child: Consumer<ChatProvider>(
          builder: (context, chatProvider, child) {
            return Column(
              children: [
                // Job Info Header
                Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
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
                    Row(
                      children: [
                        Icon(Icons.work, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.chat.application.jobPost.jobTitle,
                            style: const TextStyle(
                              fontFamily: 'FrederickaTheGreat',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.account_balance_wallet, color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '\$${widget.chat.application.jobPost.payment}',
                          style: const TextStyle(
                            fontFamily: 'LifeSavers',
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.location_on, color: Colors.red, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.chat.application.jobPost.address,
                            style: const TextStyle(
                              fontFamily: 'LifeSavers',
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Messages List
              Expanded(
                child: chatProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : chatProvider.currentChatMessages.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No messages yet',
                                  style: TextStyle(
                                    fontFamily: 'LifeSavers',
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Start the conversation!',
                                  style: TextStyle(
                                    fontFamily: 'LifeSavers',
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: MediaQuery.of(context).viewInsets.bottom, // Add padding when keyboard appears
                            ),
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // Dismiss keyboard on scroll
                            itemCount: chatProvider.currentChatMessages.length,
                            itemBuilder: (context, index) {
                              final message = chatProvider.currentChatMessages[index];
                              return _buildMessageBubble(message, currentUser!.id);
                            },
                          ),
              ),

              // Message Input
              Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 16 + MediaQuery.of(context).padding.bottom, // Add safe area padding for iOS
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextField(
                          controller: _messageController,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                          decoration: const InputDecoration(
                            labelText: 'Type a message...',
                            labelStyle: TextStyle(
                              color: Colors.black38,
                              fontFamily: 'LifeSavers',
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: chatProvider.isLoading ? null : _sendMessage,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: chatProvider.isLoading ? Colors.grey : Colors.blue,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: chatProvider.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, int currentUserId) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final isFromCurrentUser = chatProvider.isMessageFromCurrentUser(message, currentUserId);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isFromCurrentUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        children: [
          if (!isFromCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                message.sender?.name.isNotEmpty == true 
                    ? message.sender!.name[0].toUpperCase() 
                    : 'U',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isFromCurrentUser ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: isFromCurrentUser ? const Radius.circular(20) : const Radius.circular(4),
                  bottomRight: isFromCurrentUser ? const Radius.circular(4) : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(
                      fontFamily: 'LifeSavers',
                      fontSize: 16,
                      color: isFromCurrentUser ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Provider.of<ChatProvider>(context, listen: false).formatMessageTime(message.createdAt),
                    style: TextStyle(
                      fontFamily: 'LifeSavers',
                      fontSize: 12,
                      color: isFromCurrentUser 
                          ? Colors.white.withOpacity(0.7) 
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isFromCurrentUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                message.sender?.name.isNotEmpty == true 
                    ? message.sender!.name[0].toUpperCase() 
                    : 'U',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    
    chatProvider.sendMessage(
      chatId: widget.chat.id,
      message: message,
    ).then((_) {
      _messageController.clear();
      _dismissKeyboard(); // Dismiss keyboard after sending
      _scrollToBottom();
      // Refresh messages after sending to get any server-side updates
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          chatProvider.getChatMessages(widget.chat.id);
        }
      });
    });
  }

  void _showChatOptions(BuildContext context, ChatUser otherUser) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: Text(
                'View ${otherUser.name}\'s Profile',
                style: const TextStyle(fontFamily: 'LifeSavers'),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to profile
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: Text(
                'Call ${otherUser.name}',
                style: const TextStyle(fontFamily: 'LifeSavers'),
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle call
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: Text(
                'Block ${otherUser.name}',
                style: const TextStyle(fontFamily: 'LifeSavers'),
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle block
              },
            ),
          ],
        ),
      ),
    );
  }
}
