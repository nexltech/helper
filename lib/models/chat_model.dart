class ChatUser {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String role;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  ChatUser({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'role': role,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}

class ChatMessage {
  final int id;
  final String chatId;
  final String senderId;
  final String message;
  final bool isRead;
  final String createdAt;
  final String updatedAt;
  final ChatUser? sender;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    this.sender,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? 0,
      chatId: json['chat_id']?.toString() ?? '',
      senderId: json['sender_id']?.toString() ?? '',
      message: json['message'] ?? '',
      isRead: json['is_read'] == '1' || json['is_read'] == true || json['is_read'] == 1,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      sender: json['sender'] != null ? ChatUser.fromJson(json['sender']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'sender': sender?.toJson(),
    };
  }
}

class ChatApplication {
  final int id;
  final String jobPostId;
  final String userId;
  final String coverLetter;
  final String status;
  final String createdAt;
  final String updatedAt;
  final ChatJobPost jobPost;

  ChatApplication({
    required this.id,
    required this.jobPostId,
    required this.userId,
    required this.coverLetter,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.jobPost,
  });

  factory ChatApplication.fromJson(Map<String, dynamic> json) {
    return ChatApplication(
      id: json['id'] ?? 0,
      jobPostId: json['job_post_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      coverLetter: json['cover_letter'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      jobPost: ChatJobPost.fromJson(json['job_post'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_post_id': jobPostId,
      'user_id': userId,
      'cover_letter': coverLetter,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'job_post': jobPost.toJson(),
    };
  }
}

class ChatJobPost {
  final int id;
  final String userId;
  final String jobTitle;
  final String jobCategoryId;
  final String payment;
  final String address;
  final String dateTime;
  final String jobDescription;
  final String? image;
  final String status;
  final String createdAt;
  final String updatedAt;

  ChatJobPost({
    required this.id,
    required this.userId,
    required this.jobTitle,
    required this.jobCategoryId,
    required this.payment,
    required this.address,
    required this.dateTime,
    required this.jobDescription,
    this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatJobPost.fromJson(Map<String, dynamic> json) {
    return ChatJobPost(
      id: json['id'] ?? 0,
      userId: json['user_id']?.toString() ?? '',
      jobTitle: json['job_title'] ?? '',
      jobCategoryId: json['job_category_id']?.toString() ?? '',
      payment: json['payment'] ?? '',
      address: json['address'] ?? '',
      dateTime: json['date_time'] ?? '',
      jobDescription: json['job_description'] ?? '',
      image: json['image'],
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'job_title': jobTitle,
      'job_category_id': jobCategoryId,
      'payment': payment,
      'address': address,
      'date_time': dateTime,
      'job_description': jobDescription,
      'image': image,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Chat {
  final int id;
  final String applicationId;
  final String senderId;
  final String receiverId;
  final String createdAt;
  final String updatedAt;
  final ChatApplication application;
  final ChatUser sender;
  final ChatUser receiver;
  final List<ChatMessage> messages;

  Chat({
    required this.id,
    required this.applicationId,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
    required this.updatedAt,
    required this.application,
    required this.sender,
    required this.receiver,
    required this.messages,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] ?? 0,
      applicationId: json['application_id']?.toString() ?? '',
      senderId: json['sender_id']?.toString() ?? '',
      receiverId: json['receiver_id']?.toString() ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      application: ChatApplication.fromJson(json['application'] ?? {}),
      sender: ChatUser.fromJson(json['sender'] ?? {}),
      receiver: ChatUser.fromJson(json['receiver'] ?? {}),
      messages: (json['messages'] as List<dynamic>?)
          ?.map((message) => ChatMessage.fromJson(message))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'application_id': applicationId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'application': application.toJson(),
      'sender': sender.toJson(),
      'receiver': receiver.toJson(),
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}

class StartChatRequest {
  final int applicationId;
  final int receiverId;

  StartChatRequest({
    required this.applicationId,
    required this.receiverId,
  });

  Map<String, dynamic> toJson() {
    return {
      'application_id': applicationId,
      'receiver_id': receiverId,
    };
  }
}

class SendMessageRequest {
  final int chatId;
  final String message;

  SendMessageRequest({
    required this.chatId,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'chat_id': chatId,
      'message': message,
    };
  }
}

class StartChatResponse {
  final String message;
  final Chat chat;

  StartChatResponse({
    required this.message,
    required this.chat,
  });

  factory StartChatResponse.fromJson(Map<String, dynamic> json) {
    return StartChatResponse(
      message: json['message'] ?? '',
      chat: Chat.fromJson(json['chat'] ?? {}),
    );
  }
}

class SendMessageResponse {
  final String message;
  final ChatMessage data;

  SendMessageResponse({
    required this.message,
    required this.data,
  });

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
    return SendMessageResponse(
      message: json['message'] ?? '',
      data: ChatMessage.fromJson(json['data'] ?? {}),
    );
  }
}

class GetChatsResponse {
  final String message;
  final List<Chat> data;

  GetChatsResponse({
    required this.message,
    required this.data,
  });

  factory GetChatsResponse.fromJson(Map<String, dynamic> json) {
    return GetChatsResponse(
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((chat) => Chat.fromJson(chat))
          .toList() ?? [],
    );
  }
}

class GetChatMessagesResponse {
  final Chat chat;
  final List<ChatMessage> messages;

  GetChatMessagesResponse({
    required this.chat,
    required this.messages,
  });

  factory GetChatMessagesResponse.fromJson(Map<String, dynamic> json) {
    return GetChatMessagesResponse(
      chat: Chat.fromJson(json['chat'] ?? {}),
      messages: (json['messages'] as List<dynamic>?)
          ?.map((message) => ChatMessage.fromJson(message))
          .toList() ?? [],
    );
  }
}
