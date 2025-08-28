import 'package:equatable/equatable.dart';

/// Chat/Match model representing a conversation
class ChatModel extends Equatable {
  const ChatModel({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.otherUser,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
    this.isBlocked = false,
    this.isArchived = false,
    required this.createdAt,
  });

  final String id;
  final String user1Id;
  final String user2Id;
  final ChatUser otherUser;
  final Message? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final bool isBlocked;
  final bool isArchived;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id, user1Id, user2Id, otherUser, lastMessage, 
    lastMessageAt, unreadCount, isBlocked, isArchived, createdAt,
  ];

  ChatModel copyWith({
    String? id,
    String? user1Id,
    String? user2Id,
    ChatUser? otherUser,
    Message? lastMessage,
    DateTime? lastMessageAt,
    int? unreadCount,
    bool? isBlocked,
    bool? isArchived,
    DateTime? createdAt,
  }) {
    return ChatModel(
      id: id ?? this.id,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      otherUser: otherUser ?? this.otherUser,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      isBlocked: isBlocked ?? this.isBlocked,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Message model for individual chat messages
class Message extends Equatable {
  const Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    this.mediaUrl,
    this.mediaType = MediaType.none,
    this.replyTo,
    this.reactions = const [],
    this.seenBy = const [],
    this.isEdited = false,
    this.isDeleted = false,
    required this.createdAt,
  });

  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final String? mediaUrl;
  final MediaType mediaType;
  final Message? replyTo;
  final List<MessageReaction> reactions;
  final List<String> seenBy;
  final bool isEdited;
  final bool isDeleted;
  final DateTime createdAt;

  /// Check if message is sent by current user
  bool isSentByUser(String userId) => senderId == userId;

  /// Check if message has been seen by user
  bool isSeenByUser(String userId) => seenBy.contains(userId);

  /// Get message status for sender
  MessageStatus getStatus(String currentUserId, String otherUserId) {
    if (!isSentByUser(currentUserId)) return MessageStatus.received;
    
    if (isSeenByUser(otherUserId)) {
      return MessageStatus.read;
    } else if (seenBy.isNotEmpty) {
      return MessageStatus.delivered;
    } else {
      return MessageStatus.sent;
    }
  }

  @override
  List<Object?> get props => [
    id, chatId, senderId, content, mediaUrl, mediaType,
    replyTo, reactions, seenBy, isEdited, isDeleted, createdAt,
  ];

  Message copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? content,
    String? mediaUrl,
    MediaType? mediaType,
    Message? replyTo,
    List<MessageReaction>? reactions,
    List<String>? seenBy,
    bool? isEdited,
    bool? isDeleted,
    DateTime? createdAt,
  }) {
    return Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      replyTo: replyTo ?? this.replyTo,
      reactions: reactions ?? this.reactions,
      seenBy: seenBy ?? this.seenBy,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// User model for chat contexts
class ChatUser extends Equatable {
  const ChatUser({
    required this.id,
    required this.name,
    required this.profileImage,
    this.isOnline = false,
    this.lastSeen,
    this.isVerified = false,
    this.age,
  });

  final String id;
  final String name;
  final String? profileImage;
  final bool isOnline;
  final DateTime? lastSeen;
  final bool isVerified;
  final int? age;

  String get displayName => name;
  
  String get onlineStatus {
    if (isOnline) return 'Online';
    if (lastSeen != null) {
      final now = DateTime.now();
      final difference = now.difference(lastSeen!);
      
      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    }
    return 'Offline';
  }

  @override
  List<Object?> get props => [
    id, name, profileImage, isOnline, lastSeen, isVerified, age,
  ];

  ChatUser copyWith({
    String? id,
    String? name,
    String? profileImage,
    bool? isOnline,
    DateTime? lastSeen,
    bool? isVerified,
    int? age,
  }) {
    return ChatUser(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      isVerified: isVerified ?? this.isVerified,
      age: age ?? this.age,
    );
  }
}

/// Message reaction model
class MessageReaction extends Equatable {
  const MessageReaction({
    required this.userId,
    required this.emoji,
    required this.createdAt,
  });

  final String userId;
  final String emoji;
  final DateTime createdAt;

  @override
  List<Object?> get props => [userId, emoji, createdAt];
}

/// Typing indicator model
class TypingIndicator extends Equatable {
  const TypingIndicator({
    required this.userId,
    required this.chatId,
    required this.isTyping,
    required this.updatedAt,
  });

  final String userId;
  final String chatId;
  final bool isTyping;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [userId, chatId, isTyping, updatedAt];
}

/// Enums
enum MediaType {
  none,
  image,
  audio,
  video,
  file,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
  received,
}

extension MediaTypeExtension on MediaType {
  String get displayName {
    switch (this) {
      case MediaType.none:
        return 'Text';
      case MediaType.image:
        return 'Image';
      case MediaType.audio:
        return 'Audio';
      case MediaType.video:
        return 'Video';
      case MediaType.file:
        return 'File';
    }
  }

  IconData get icon {
    switch (this) {
      case MediaType.none:
        return Icons.message;
      case MediaType.image:
        return Icons.image;
      case MediaType.audio:
        return Icons.mic;
      case MediaType.video:
        return Icons.videocam;
      case MediaType.file:
        return Icons.attach_file;
    }
  }
}

/// Message helper extensions
extension MessageHelpers on Message {
  /// Get display content with media type consideration
  String get displayContent {
    if (isDeleted) return 'This message was deleted';
    
    switch (mediaType) {
      case MediaType.none:
        return content;
      case MediaType.image:
        return '📷 Image';
      case MediaType.audio:
        return '🎵 Audio message';
      case MediaType.video:
        return '🎬 Video';
      case MediaType.file:
        return '📎 File';
    }
  }

  /// Check if message contains media
  bool get hasMedia => mediaType != MediaType.none && mediaUrl != null;

  /// Get formatted time
  String get formattedTime {
    final now = DateTime.now();
    final messageTime = createdAt;
    
    if (now.day == messageTime.day &&
        now.month == messageTime.month &&
        now.year == messageTime.year) {
      // Today - show time only
      return '${messageTime.hour.toString().padLeft(2, '0')}:${messageTime.minute.toString().padLeft(2, '0')}';
    } else if (now.difference(messageTime).inDays == 1) {
      // Yesterday
      return 'Yesterday';
    } else if (now.difference(messageTime).inDays < 7) {
      // This week - show day name
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[messageTime.weekday - 1];
    } else {
      // Older - show date
      return '${messageTime.day}/${messageTime.month}/${messageTime.year}';
    }
  }
}
