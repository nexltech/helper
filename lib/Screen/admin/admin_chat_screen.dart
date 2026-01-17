import 'package:flutter/material.dart';
import 'package:job/Screen/jobBoarding/navbar.dart';

class AdminChatScreen extends StatefulWidget {
  const AdminChatScreen({super.key});

  @override
  State<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Sample chat data
  final List<ChatMessage> _messages = [
    ChatMessage(
      sender: 'You',
      message: "Hey, need you tomorrow from 9 to 5 at Oak St. OK?",
      timestamp: '9:30AM',
      isFromUser: true,
    ),
    ChatMessage(
      sender: 'John Marvel',
      message: "Sounds good - I'll confirm shortly.",
      timestamp: '9:30AM',
      isFromUser: false,
    ),
    ChatMessage(
      sender: 'You',
      message: "Perfect. Enter through side entrance. Thanks!",
      timestamp: '9:30AM',
      isFromUser: true,
    ),
    ChatMessage(
      sender: 'You',
      message: "I've been waiting for the response.",
      timestamp: '9:30AM',
      isFromUser: true,
    ),
    ChatMessage(
      sender: 'John Marvel',
      message: "OK! I'll b there at tomorrow.",
      timestamp: '12:00AM',
      isFromUser: false,
    ),
  ];

  final List<ChatContact> _contacts = [
    ChatContact(
      name: 'John M.',
      lastMessage: "I've been waiting for the response",
      timestamp: '2:01 pm',
      hasUnread: false,
      profileImage: 'https://randomuser.me/api/portraits/men/1.jpg',
    ),
    ChatContact(
      name: 'Alex W.',
      lastMessage: "Yes, sure I will check it out and will let...",
      timestamp: '2:01 pm',
      hasUnread: true,
      unreadCount: 1,
      profileImage: 'https://randomuser.me/api/portraits/men/2.jpg',
    ),
    ChatContact(
      name: 'Cody C.',
      lastMessage: "I've been waiting for the response",
      timestamp: '2:01 pm',
      hasUnread: false,
      profileImage: 'https://randomuser.me/api/portraits/men/3.jpg',
    ),
    ChatContact(
      name: 'James L.',
      lastMessage: "I've been waiting for the response",
      timestamp: '2:01 pm',
      hasUnread: false,
      profileImage: 'https://randomuser.me/api/portraits/men/4.jpg',
    ),
    ChatContact(
      name: 'Robert M.',
      lastMessage: "OMG, this is amazing 😉",
      timestamp: '2:01 pm',
      hasUnread: false,
      profileImage: 'https://randomuser.me/api/portraits/men/5.jpg',
    ),
    ChatContact(
      name: 'Sheimas K.',
      lastMessage: "Haha that's terrifying",
      timestamp: '2:01 pm',
      hasUnread: false,
      profileImage: 'https://randomuser.me/api/portraits/men/6.jpg',
    ),
    ChatContact(
      name: 'Rock B.',
      lastMessage: "Perfect! Will give you an update tomorrow.",
      timestamp: '2:01 pm',
      hasUnread: false,
      profileImage: 'https://randomuser.me/api/portraits/men/7.jpg',
    ),
    ChatContact(
      name: 'Zayn Aly',
      lastMessage: "I've been waiting for the response",
      timestamp: '2:01 pm',
      hasUnread: false,
      profileImage: 'https://randomuser.me/api/portraits/men/8.jpg',
    ),
  ];

  bool _isInChatView = false;
  ChatContact? _currentContact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: _isInChatView ? _buildChatView() : _buildInboxView(),
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
                content: Text('New Message - Coming Soon'),
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

  Widget _buildInboxView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Header
            _buildInboxHeader(),
            const SizedBox(height: 12),
            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 16),
            // Messages List
            _buildMessagesList(),
            const SizedBox(height: 80), // Spacer for navbar
          ],
        ),
      ),
    );
  }

  Widget _buildInboxHeader() {
    return Container(
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
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            alignment: Alignment.center,
            child: const Text(
              'H',
              style: TextStyle(
                fontFamily: 'FrederickatheGreat',
                fontSize: 40,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Inbox',
              style: TextStyle(
                fontFamily: 'HomemadeApple',
                fontSize: 28,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Center(
              child: Image.asset(
                'assets/Icons/Alarm.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                color: Colors.green,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.notifications,
                    color: Colors.green,
                    size: 24,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(
          fontFamily: 'LifeSavers',
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: 'Search',
          labelStyle: const TextStyle(
            color: Colors.black38,
            fontFamily: 'LifeSavers',
          ),
          border: InputBorder.none,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(Icons.search, color: Colors.black26),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return _buildMessageItem(contact);
        },
      ),
    );
  }

  Widget _buildMessageItem(ChatContact contact) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isInChatView = true;
          _currentContact = contact;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(contact.profileImage),
                ),
                if (contact.hasUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '${contact.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: const TextStyle(
                      fontFamily: 'LifeSavers',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contact.lastMessage,
                    style: const TextStyle(
                      fontFamily: 'LifeSavers',
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              contact.timestamp,
              style: const TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatView() {
    return Column(
      children: [
        // Chat Header
        _buildChatHeader(),
        // Messages
        Expanded(
          child: Container(
            color: Colors.grey.shade50,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildChatBubble(message);
              },
            ),
          ),
        ),
        // Message Input
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildChatHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _isInChatView = false;
                _currentContact = null;
              });
            },
            icon: const Icon(Icons.arrow_back_ios, size: 20),
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(_currentContact?.profileImage ?? ''),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _currentContact?.name ?? 'John M.',
              style: const TextStyle(
                fontFamily: 'LifeSavers',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: const Center(
              child: Icon(
                Icons.warning,
                color: Colors.red,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isFromUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        children: [
          if (!message.isFromUser) ...[
            CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(_currentContact?.profileImage ?? ''),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isFromUser ? Colors.green.shade100 : Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message.message,
                style: const TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          if (message.isFromUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(_currentContact?.profileImage ?? ''),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Enter your text here',
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontFamily: 'LifeSavers',
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String sender;
  final String message;
  final String timestamp;
  final bool isFromUser;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
    required this.isFromUser,
  });
}

class ChatContact {
  final String name;
  final String lastMessage;
  final String timestamp;
  final bool hasUnread;
  final int? unreadCount;
  final String profileImage;

  ChatContact({
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    required this.hasUnread,
    this.unreadCount,
    required this.profileImage,
  });
}
