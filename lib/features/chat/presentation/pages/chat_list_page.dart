import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/main_scaffold.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/models/chat_models.dart';
import '../../../../shared/widgets/profile_photo.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String _currentUserId = 'current_user_id'; // TODO: Get from auth

  // Mock data - replace with real data from backend
  final List<ChatModel> _mockChats = [
    ChatModel(
      id: '1',
      user1Id: 'current_user_id',
      user2Id: '2',
      otherUser: const ChatUser(
        id: '2',
        name: 'Meron Tadesse',
        profileImage: null,
        isOnline: true,
        isVerified: true,
        age: 25,
      ),
      lastMessage: Message(
        id: 'msg1',
        chatId: '1',
        senderId: '2',
        content: 'Hey! How was your day? 😊',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      lastMessageAt: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ChatModel(
      id: '2',
      user1Id: 'current_user_id',
      user2Id: '3',
      otherUser: const ChatUser(
        id: '3',
        name: 'Daniel Gebre',
        profileImage: null,
        isOnline: false,
        lastSeen: null, // Will be set
        isVerified: false,
        age: 28,
      ),
      lastMessage: Message(
        id: 'msg2',
        chatId: '2',
        senderId: 'current_user_id',
        content: 'Thanks for the recommendation!',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ChatModel(
      id: '3',
      user1Id: 'current_user_id',
      user2Id: '4',
      otherUser: const ChatUser(
        id: '4',
        name: 'Sara Kidane',
        profileImage: null,
        isOnline: false,
        lastSeen: null,
        isVerified: true,
        age: 24,
      ),
      lastMessage: Message(
        id: 'msg3',
        chatId: '3',
        senderId: '4',
        content: '📷 Image',
        mediaType: MediaType.image,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      lastMessageAt: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 1,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _mockChats
        .where((chat) => chat.unreadCount > 0)
        .fold<int>(0, (sum, chat) => sum + chat.unreadCount);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Messages',
        actions: [
          // Search button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search coming soon!')),
              );
            },
          ),
          // More options
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'new_group':
                  // TODO: Implement new group
                  break;
                case 'settings':
                  context.push(AppRoutes.settings);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'new_group',
                child: Row(
                  children: [
                    Icon(Icons.group_add),
                    SizedBox(width: 12),
                    Text('New Group'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 12),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('All'),
                  if (unreadCount > 0) ...
                    [
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                ],
              ),
            ),
            const Tab(text: 'Unread'),
            const Tab(text: 'Groups'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All chats
          _buildChatList(_mockChats),
          // Unread chats
          _buildChatList(_mockChats.where((c) => c.unreadCount > 0).toList()),
          // Groups (empty for now)
          _buildEmptyState(
            icon: Icons.group,
            title: 'No Groups Yet',
            subtitle: 'Create or join groups to chat with multiple people.',
            actionText: 'Create Group',
            onAction: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Group chat coming soon!')),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to new chat/matches
          context.go(AppRoutes.matches);
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildChatList(List<ChatModel> chats) {
    if (chats.isEmpty) {
      return _buildEmptyState(
        icon: Icons.chat_bubble_outline,
        title: 'No Messages Yet',
        subtitle: 'Start matching with people to begin conversations!',
        actionText: 'Find Matches',
        onAction: () => context.go(AppRoutes.discovery),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh chats from server
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        itemCount: chats.length,
        separatorBuilder: (context, index) => Divider(
          indent: AppSpacing.avatarLG + AppSpacing.md * 2,
          height: 1,
        ),
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ChatListItem(
            chat: chat,
            currentUserId: _currentUserId,
            onTap: () {
              context.push(
                AppRoutes.chatWithId(chat.id),
                extra: {
                  'chat': chat,
                  'otherUser': chat.otherUser,
                },
              );
            },
            onLongPress: () {
              _showChatOptions(chat);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionText),
            ),
          ],
        ),
      ),
    );
  }

  void _showChatOptions(ChatModel chat) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: AppSpacing.paddingLG,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                ProfilePhoto(
                  imageUrl: chat.otherUser.profileImage,
                  size: AppSpacing.avatarMD,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.otherUser.displayName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        chat.otherUser.onlineStatus,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Options
            _buildOption(
              icon: Icons.person,
              text: 'View Profile',
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.profileWithId(chat.otherUser.id));
              },
            ),
            _buildOption(
              icon: Icons.volume_off,
              text: 'Mute Notifications',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement mute
              },
            ),
            _buildOption(
              icon: Icons.archive,
              text: 'Archive Chat',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement archive
              },
            ),
            _buildOption(
              icon: Icons.block,
              text: 'Block User',
              textColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                _showBlockConfirmation(chat);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            Icon(
              icon,
              color: textColor ?? Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockConfirmation(ChatModel chat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: Text(
          'Are you sure you want to block ${chat.otherUser.displayName}? You will no longer receive messages from them.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement block user
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${chat.otherUser.displayName} has been blocked'),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }
}

// Chat List Item Widget
class ChatListItem extends StatelessWidget {
  const ChatListItem({
    super.key,
    required this.chat,
    required this.currentUserId,
    required this.onTap,
    this.onLongPress,
  });

  final ChatModel chat;
  final String currentUserId;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final hasUnread = chat.unreadCount > 0;
    final lastMessage = chat.lastMessage;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: AppSpacing.paddingMD,
          child: Row(
            children: [
              // Profile photo with online indicator
              Stack(
                children: [
                  ProfilePhoto(
                    imageUrl: chat.otherUser.profileImage,
                    size: AppSpacing.avatarLG,
                    isOnline: chat.otherUser.isOnline,
                    isVerified: chat.otherUser.isVerified,
                  ),
                  if (hasUnread)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            chat.unreadCount > 9 
                                ? '9+' 
                                : chat.unreadCount.toString(),
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
              const SizedBox(width: AppSpacing.md),
              
              // Chat info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and time row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat.otherUser.displayName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: hasUnread 
                                  ? FontWeight.w600 
                                  : FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (chat.lastMessageAt != null)
                          Text(
                            _formatTime(chat.lastMessageAt!),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: hasUnread 
                                  ? Theme.of(context).primaryColor 
                                  : Theme.of(context).colorScheme.outline,
                              fontWeight: hasUnread 
                                  ? FontWeight.w600 
                                  : FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    
                    // Last message and status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _getLastMessageText(lastMessage),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: hasUnread 
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context).colorScheme.outline,
                              fontWeight: hasUnread 
                                  ? FontWeight.w500 
                                  : FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (lastMessage != null && 
                            lastMessage.isSentByUser(currentUserId))
                          Padding(
                            padding: const EdgeInsets.only(left: AppSpacing.xs),
                            child: Icon(
                              _getMessageStatusIcon(lastMessage),
                              size: 16,
                              color: _getMessageStatusColor(lastMessage),
                            ),
                          ),
                      ],
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

  String _getLastMessageText(Message? message) {
    if (message == null) return 'Say hello! 👋';
    
    if (message.mediaType != MediaType.none) {
      switch (message.mediaType) {
        case MediaType.image:
          return '📷 Photo';
        case MediaType.audio:
          return '🎵 Voice message';
        case MediaType.video:
          return '🎬 Video';
        case MediaType.file:
          return '📎 File';
        case MediaType.none:
          break;
      }
    }
    
    return message.content;
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(time.year, time.month, time.day);
    
    if (messageDate == today) {
      // Today - show time
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      // Yesterday
      return 'Yesterday';
    } else if (now.difference(messageDate).inDays < 7) {
      // This week - show day name
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[time.weekday - 1];
    } else {
      // Older - show date
      return '${time.day}/${time.month}';
    }
  }

  IconData _getMessageStatusIcon(Message message) {
    // Simplified status for now
    return Icons.done;
  }

  Color _getMessageStatusColor(Message message) {
    // Simplified for now
    return Colors.grey;
  }
}
