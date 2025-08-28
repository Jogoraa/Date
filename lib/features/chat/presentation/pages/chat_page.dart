import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/models/chat_models.dart';
import '../../../../shared/widgets/profile_photo.dart';
import '../widgets/chat_widgets.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.chatId,
    this.matchData,
  });

  final String chatId;
  final Map<String, dynamic>? matchData;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final String _currentUserId = 'current_user_id'; // TODO: Get from auth
  
  // State management
  bool _isLoading = true;
  bool _isTyping = false;
  bool _isRecording = false;
  Duration _recordingDuration = Duration.zero;
  List<String> _selectedMessageIds = [];
  bool _isSelectionMode = false;
  
  // Mock messages - replace with real data
  List<Message> _messages = [];
  ChatUser? _otherUser;
  
  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _loadChatData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _loadChatData() async {
    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Extract data from matchData or use defaults
    final matchData = widget.matchData;
    _otherUser = matchData != null && matchData['otherUser'] != null 
        ? matchData['otherUser'] as ChatUser
        : const ChatUser(
            id: '2',
            name: 'Sample User',
            profileImage: null,
            isOnline: true,
            isVerified: false,
            age: 25,
          );
    
    // Mock data - replace with actual API call
    setState(() {
      _messages = [
        Message(
          id: '1',
          chatId: widget.chatId,
          senderId: _otherUser!.id,
          content: 'Hey! How are you doing today? 😊',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Message(
          id: '2',
          chatId: widget.chatId,
          senderId: _currentUserId,
          content: 'Hi! I\'m doing great, thanks for asking! Just finished work and thinking about getting some injera for dinner 🍽️',
          createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
        ),
        Message(
          id: '3',
          chatId: widget.chatId,
          senderId: _otherUser!.id,
          content: 'That sounds delicious! I love injera too. Which restaurant are you thinking of?',
          createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
        ),
        Message(
          id: '4',
          chatId: widget.chatId,
          senderId: _currentUserId,
          content: 'There\'s this amazing Ethiopian place called "Taste of Habesha" downtown. Have you been there?',
          createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        ),
        Message(
          id: '5',
          chatId: widget.chatId,
          senderId: _otherUser!.id,
          content: '📷 Image',
          mediaType: MediaType.image,
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        Message(
          id: '6',
          chatId: widget.chatId,
          senderId: _otherUser!.id,
          content: 'I went there last week! The doro wat was incredible 🔥',
          createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
        ),
        Message(
          id: '7',
          chatId: widget.chatId,
          senderId: _currentUserId,
          content: 'Yes! Their doro wat is the best in the city. We should go together sometime!',
          createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
        ),
      ];
      _isLoading = false;
    });
    
    _fadeController.forward();
    
    // Auto-scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom({bool animated = true}) {
    if (_scrollController.hasClients) {
      if (animated) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    }
  }

  void _sendMessage(String content) {
    if (content.trim().isEmpty) return;
    
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: widget.chatId,
      senderId: _currentUserId,
      content: content.trim(),
      createdAt: DateTime.now(),
    );
    
    setState(() {
      _messages.add(newMessage);
    });
    
    // Scroll to bottom after sending
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    
    // Simulate typing response after a delay
    _simulateTypingResponse();
  }

  void _simulateTypingResponse() async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() {
        _isTyping = true;
      });
      
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
        
        // Add response message
        final responses = [
          'That would be amazing! When are you free? 😊',
          'I\'d love to! Let me know when works for you',
          'Perfect! Looking forward to it ✨',
          'Great idea! Ethiopian food is always better with good company 💕',
        ];
        
        final randomResponse = responses[
          DateTime.now().millisecond % responses.length
        ];
        
        final responseMessage = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          chatId: widget.chatId,
          senderId: _otherUser?.id ?? '2',
          content: randomResponse,
          createdAt: DateTime.now(),
        );
        
        setState(() {
          _messages.add(responseMessage);
        });
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    }
  }

  void _onMessageTap(Message message) {
    if (_isSelectionMode) {
      _toggleMessageSelection(message.id);
    }
  }

  void _onMessageLongPress(Message message) {
    HapticFeedback.mediumImpact();
    if (!_isSelectionMode) {
      setState(() {
        _isSelectionMode = true;
        _selectedMessageIds = [message.id];
      });
      _slideController.forward();
    } else {
      _toggleMessageSelection(message.id);
    }
  }

  void _toggleMessageSelection(String messageId) {
    setState(() {
      if (_selectedMessageIds.contains(messageId)) {
        _selectedMessageIds.remove(messageId);
      } else {
        _selectedMessageIds.add(messageId);
      }
      
      if (_selectedMessageIds.isEmpty) {
        _isSelectionMode = false;
        _slideController.reverse();
      }
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedMessageIds.clear();
    });
    _slideController.reverse();
  }

  void _deleteSelectedMessages() {
    setState(() {
      _messages.removeWhere((msg) => _selectedMessageIds.contains(msg.id));
    });
    _exitSelectionMode();
    HapticFeedback.lightImpact();
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordingDuration = Duration.zero;
    });
    // TODO: Start actual audio recording
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
      _recordingDuration = Duration.zero;
    });
    // TODO: Stop recording and send audio message
  }

  @override
  Widget build(BuildContext context) {
    if (_otherUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(_otherUser!),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: _buildMessagesList(),
          ),
          
          // Typing indicator
          if (_isTyping)
            TypingIndicator(
              userName: _otherUser!.displayName,
            ),
          
          // Message input
          MessageInput(
            onSendMessage: _sendMessage,
            onSendMedia: () {
              // TODO: Implement media picker
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Media picker coming soon!')),
              );
            },
            onStartRecording: _startRecording,
            onStopRecording: _stopRecording,
            isRecording: _isRecording,
            recordingDuration: _recordingDuration,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ChatUser otherUser) {
    if (_isSelectionMode) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _exitSelectionMode,
        ),
        title: Text('${_selectedMessageIds.length} selected'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              // TODO: Implement copy messages
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copy coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.forward),
            onPressed: () {
              // TODO: Implement forward messages
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Forward coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteSelectedMessages,
          ),
        ],
      );
    }
    
    return AppBar(
      titleSpacing: 0,
      title: InkWell(
        onTap: () {
          context.push(AppRoutes.profileWithId(otherUser.id));
        },
        child: Row(
          children: [
            ProfilePhoto(
              imageUrl: otherUser.profileImage,
              size: AppSpacing.avatarMD,
              isOnline: otherUser.isOnline,
              isVerified: otherUser.isVerified,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUser.displayName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    otherUser.onlineStatus,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: otherUser.isOnline
                          ? Colors.green
                          : Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () {
            // TODO: Start video call
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Video call coming soon!')),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.call),
          onPressed: () {
            // TODO: Start voice call
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Voice call coming soon!')),
            );
          },
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'view_profile':
                context.push(AppRoutes.profileWithId(otherUser.id));
                break;
              case 'media':
                // TODO: Show shared media
                break;
              case 'search':
                // TODO: Search in conversation
                break;
              case 'mute':
                // TODO: Mute conversation
                break;
              case 'block':
                _showBlockDialog(otherUser);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view_profile',
              child: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 12),
                  Text('View Profile'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'media',
              child: Row(
                children: [
                  Icon(Icons.photo_library),
                  SizedBox(width: 12),
                  Text('Media, Links, Docs'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'search',
              child: Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 12),
                  Text('Search'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'mute',
              child: Row(
                children: [
                  Icon(Icons.volume_off),
                  SizedBox(width: 12),
                  Text('Mute Notifications'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'block',
              child: Row(
                children: [
                  Icon(Icons.block, color: Colors.red),
                  SizedBox(width: 12),
                  Text('Block User', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessagesList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (_messages.isEmpty) {
      return _buildEmptyState();
    }

    return FadeTransition(
      opacity: _fadeController,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          final isOwnMessage = message.isSentByUser(_currentUserId);
          final showAvatar = _shouldShowAvatar(index, isOwnMessage);
          final showTimestamp = _shouldShowTimestamp(index);
          final isSelected = _selectedMessageIds.contains(message.id);
          
          return MessageBubble(
            message: message,
            isOwnMessage: isOwnMessage,
            showAvatar: showAvatar,
            showTimestamp: showTimestamp,
            isSelected: isSelected,
            onTap: () => _onMessageTap(message),
            onLongPress: () => _onMessageLongPress(message),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final otherUser = _otherUser!;
    
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfilePhoto(
              imageUrl: otherUser.profileImage,
              size: 80,
              isVerified: otherUser.isVerified,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              otherUser.displayName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'You matched with ${otherUser.name}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Start the conversation with a greeting!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  bool _shouldShowAvatar(int index, bool isOwnMessage) {
    if (isOwnMessage) return false;
    if (index == _messages.length - 1) return true;
    
    final currentMessage = _messages[index];
    final nextMessage = _messages[index + 1];
    
    return currentMessage.senderId != nextMessage.senderId;
  }

  bool _shouldShowTimestamp(int index) {
    if (index == 0) return true;
    
    final currentMessage = _messages[index];
    final previousMessage = _messages[index - 1];
    
    if (currentMessage.createdAt == null || previousMessage.createdAt == null) {
      return false;
    }
    
    final timeDifference = currentMessage.createdAt!
        .difference(previousMessage.createdAt!)
        .inMinutes;
    
    return timeDifference > 5; // Show timestamp if more than 5 minutes apart
  }

  void _showBlockDialog(ChatUser otherUser) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: Text(
          'Are you sure you want to block ${otherUser.displayName}? They will no longer be able to message you.',
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
              context.pop(); // Go back to chat list
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${otherUser.displayName} has been blocked'),
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
