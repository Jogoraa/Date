import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/models/chat_models.dart';
import '../../../../shared/widgets/profile_photo.dart';

// Message Bubble Widget
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isOwnMessage,
    this.showAvatar = false,
    this.showTimestamp = false,
    this.onLongPress,
    this.onTap,
    this.isSelected = false,
  });

  final Message message;
  final bool isOwnMessage;
  final bool showAvatar;
  final bool showTimestamp;
  final VoidCallback? onLongPress;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: EdgeInsets.only(
        top: AppSpacing.xs,
        bottom: showTimestamp ? AppSpacing.md : AppSpacing.xs,
        left: isOwnMessage ? AppSpacing.xl : AppSpacing.md,
        right: isOwnMessage ? AppSpacing.md : AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: isOwnMessage 
            ? CrossAxisAlignment.end 
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isOwnMessage 
                ? MainAxisAlignment.end 
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Avatar for other user's messages
              if (!isOwnMessage && showAvatar) ...[
                const ProfilePhoto(
                  imageUrl: null, // TODO: Get from message sender
                  size: AppSpacing.avatarSM,
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              
              // Message content
              Flexible(
                child: GestureDetector(
                  onTap: onTap,
                  onLongPress: onLongPress,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.all(
                      message.mediaType != MediaType.none 
                          ? AppSpacing.xs 
                          : AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary.withOpacity(0.1)
                          : isOwnMessage
                              ? colorScheme.primary
                              : colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(
                          isOwnMessage ? 18 : 6,
                        ),
                        bottomRight: Radius.circular(
                          isOwnMessage ? 6 : 18,
                        ),
                      ),
                      border: isSelected 
                          ? Border.all(
                              color: colorScheme.primary,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Message content based on type
                        _buildMessageContent(context),
                        
                        // Message info (time and status)
                        if (message.content.isNotEmpty || 
                            message.mediaType == MediaType.none)
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xs),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formatMessageTime(message.createdAt),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isOwnMessage
                                        ? colorScheme.onPrimary.withOpacity(0.8)
                                        : colorScheme.onSurfaceVariant.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                                if (isOwnMessage) ...[
                                  const SizedBox(width: AppSpacing.xs),
                                  Icon(
                                    _getStatusIcon(),
                                    size: 16,
                                    color: colorScheme.onPrimary.withOpacity(0.8),
                                  ),
                                ],
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Spacing for own messages
              if (isOwnMessage && showAvatar)
                const SizedBox(width: AppSpacing.avatarSM + AppSpacing.xs),
            ],
          ),
          
          // Timestamp row
          if (showTimestamp)
            Container(
              margin: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                _formatTimestamp(message.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (message.mediaType) {
      case MediaType.image:
        return _ImageMessage(message: message);
      case MediaType.audio:
        return _AudioMessage(message: message);
      case MediaType.video:
        return _VideoMessage(message: message);
      case MediaType.file:
        return _FileMessage(message: message);
      case MediaType.none:
        return _TextMessage(
          message: message,
          textColor: isOwnMessage
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurfaceVariant,
        );
    }
  }

  IconData _getStatusIcon() {
    // TODO: Implement proper message status
    return Icons.done; // Simplified for now
  }

  String _formatMessageTime(DateTime? time) {
    if (time == null) return '';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatTimestamp(DateTime? time) {
    if (time == null) return '';
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(time.year, time.month, time.day);
    
    if (messageDate == today) {
      return 'Today at ${_formatMessageTime(time)}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday at ${_formatMessageTime(time)}';
    } else {
      return '${time.day}/${time.month}/${time.year} at ${_formatMessageTime(time)}';
    }
  }
}

// Text Message Widget
class _TextMessage extends StatelessWidget {
  const _TextMessage({
    required this.message,
    required this.textColor,
  });

  final Message message;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      message.content,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: textColor,
        height: 1.4,
      ),
    );
  }
}

// Image Message Widget
class _ImageMessage extends StatelessWidget {
  const _ImageMessage({required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
            maxHeight: 300,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: const Center(
                  child: Icon(
                    Icons.image,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (message.content.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            message.content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}

// Audio Message Widget
class _AudioMessage extends StatefulWidget {
  const _AudioMessage({required this.message});

  final Message message;

  @override
  State<_AudioMessage> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<_AudioMessage>
    with TickerProviderStateMixin {
  bool isPlaying = false;
  double progress = 0.0;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _waveController.repeat();
      } else {
        _waveController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          // Play button
          GestureDetector(
            onTap: _togglePlayback,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          
          // Waveform visualization
          Expanded(
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  painter: WaveformPainter(
                    progress: progress,
                    animationValue: _waveController.value,
                    isPlaying: isPlaying,
                  ),
                  size: const Size(double.infinity, 30),
                );
              },
            ),
          ),
          
          const SizedBox(width: AppSpacing.sm),
          
          // Duration
          Text(
            '0:42', // TODO: Get actual duration
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Audio Waveform
class WaveformPainter extends CustomPainter {
  final double progress;
  final double animationValue;
  final bool isPlaying;

  WaveformPainter({
    required this.progress,
    required this.animationValue,
    required this.isPlaying,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final barWidth = size.width / 20;
    final centerY = size.height / 2;

    for (int i = 0; i < 20; i++) {
      final x = i * barWidth + barWidth / 2;
      final baseHeight = (i % 3 + 1) * 8.0;
      final animatedHeight = isPlaying 
          ? baseHeight * (0.5 + 0.5 * (animationValue * 2 - (i / 20)).abs().clamp(0.0, 1.0))
          : baseHeight;
      
      paint.color = i / 20 <= progress 
          ? Colors.blue 
          : Colors.grey.withOpacity(0.5);
      
      canvas.drawLine(
        Offset(x, centerY - animatedHeight / 2),
        Offset(x, centerY + animatedHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Video Message Widget
class _VideoMessage extends StatelessWidget {
  const _VideoMessage({required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Video thumbnail placeholder
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: const Center(
                  child: Icon(
                    Icons.videocam,
                    size: 48,
                  ),
                ),
              ),
              
              // Play button
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              
              // Duration badge
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '0:15', // TODO: Get actual duration
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        if (message.content.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            message.content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}

// File Message Widget
class _FileMessage extends StatelessWidget {
  const _FileMessage({required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              _getFileIcon(message.content),
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getFileName(message.content),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                _getFileSize(message.content),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'zip':
      case 'rar':
        return Icons.archive;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _getFileName(String content) {
    // Extract filename from content or use placeholder
    return content.isNotEmpty ? content : 'Document';
  }

  String _getFileSize(String content) {
    // TODO: Get actual file size
    return '2.3 MB';
  }
}

// Typing Indicator Widget
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({
    super.key,
    this.userName = 'Someone',
  });

  final String userName;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: AppSpacing.xs,
        horizontal: AppSpacing.md,
      ),
      child: Row(
        children: [
          const ProfilePhoto(
            imageUrl: null, // TODO: Get typing user's avatar
            size: AppSpacing.avatarSM,
          ),
          const SizedBox(width: AppSpacing.xs),
          
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(6),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.userName} is typing',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                
                // Animated dots
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        final delay = index * 0.2;
                        final animationValue = (_controller.value - delay).clamp(0.0, 1.0);
                        final scale = 0.5 + 0.5 * (1.0 - (2 * animationValue - 1).abs());
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Message Input Widget
class MessageInput extends StatefulWidget {
  const MessageInput({
    super.key,
    required this.onSendMessage,
    this.onSendMedia,
    this.onStartRecording,
    this.onStopRecording,
    this.isRecording = false,
    this.recordingDuration = Duration.zero,
  });

  final Function(String) onSendMessage;
  final VoidCallback? onSendMedia;
  final VoidCallback? onStartRecording;
  final VoidCallback? onStopRecording;
  final bool isRecording;
  final Duration recordingDuration;

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;
  late AnimationController _recordingController;
  late AnimationController _sendButtonController;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    
    _recordingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _sendButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _recordingController.dispose();
    _sendButtonController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
        if (hasText) {
          _sendButtonController.forward();
        } else {
          _sendButtonController.reverse();
        }
      });
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _controller.clear();
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    if (widget.isRecording) {
      _recordingController.repeat();
    } else {
      _recordingController.stop();
    }
    
    return Container(
      padding: AppSpacing.paddingMD,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: widget.isRecording ? _buildRecordingUI() : _buildInputUI(),
    );
  }

  Widget _buildInputUI() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SafeArea(
      child: Row(
        children: [
          // Media button
          IconButton(
            onPressed: widget.onSendMedia,
            icon: const Icon(Icons.add),
            style: IconButton.styleFrom(
              foregroundColor: colorScheme.primary,
            ),
          ),
          
          // Text input
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  border: InputBorder.none,
                  suffixIcon: !_hasText
                      ? IconButton(
                          onPressed: () {
                            // TODO: Show emoji picker
                          },
                          icon: const Icon(Icons.emoji_emotions_outlined),
                        )
                      : null,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          
          const SizedBox(width: AppSpacing.sm),
          
          // Send/Record button
          AnimatedBuilder(
            animation: _sendButtonController,
            builder: (context, child) {
              return GestureDetector(
                onTap: _hasText ? _sendMessage : null,
                onLongPressStart: _hasText ? null : (_) {
                  widget.onStartRecording?.call();
                  HapticFeedback.mediumImpact();
                },
                onLongPressEnd: _hasText ? null : (_) {
                  widget.onStopRecording?.call();
                  HapticFeedback.lightImpact();
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _hasText ? Icons.send : Icons.mic,
                    color: colorScheme.onPrimary,
                    size: _hasText ? 20 : 24,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingUI() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SafeArea(
      child: Row(
        children: [
          // Cancel button
          IconButton(
            onPressed: () {
              widget.onStopRecording?.call();
            },
            icon: const Icon(Icons.close),
            style: IconButton.styleFrom(
              foregroundColor: colorScheme.error,
            ),
          ),
          
          // Recording indicator
          Expanded(
            child: Container(
              padding: AppSpacing.paddingMD,
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: _recordingController,
                    builder: (context, child) {
                      return Icon(
                        Icons.mic,
                        color: colorScheme.error,
                        size: 20 + 4 * _recordingController.value,
                      );
                    },
                  ),
                  const SizedBox(width: AppSpacing.md),
                  
                  Text(
                    _formatDuration(widget.recordingDuration),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onErrorContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  Text(
                    'Release to send',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onErrorContainer.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: AppSpacing.sm),
          
          // Send recording button
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.send,
              color: colorScheme.onPrimary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
}

// Message Status Widget
class MessageStatus extends StatelessWidget {
  const MessageStatus({
    super.key,
    required this.status,
    this.size = 16,
  });

  final MessageStatus status;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getStatusIcon(),
      size: size,
      color: _getStatusColor(context),
    );
  }

  IconData _getStatusIcon() {
    // TODO: Implement proper status handling
    return Icons.done;
  }

  Color _getStatusColor(BuildContext context) {
    // TODO: Implement proper status colors
    return Theme.of(context).colorScheme.outline;
  }
}
