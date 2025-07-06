import 'dart:math' as math;

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:dekorner_recipe/providers/app/app_provider.dart';
import 'package:dekorner_recipe/screens/login/login_screen_arguments.dart';
import 'package:dekorner_recipe/services/recipe_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final aiChatProvider =
    StateNotifierProvider<_AIChatNotifier, List<_AIChatMessage>>(
        (ref) => _AIChatNotifier(ref));

class _AIChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? id;

  _AIChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
    this.id,
  }) : timestamp = timestamp ?? DateTime.now();
}

class _AIChatNotifier extends StateNotifier<List<_AIChatMessage>> {
  final Ref ref;
  _AIChatNotifier(this.ref) : super([]);

  Future<void> sendMessage(String message) async {
    final userMessage = _AIChatMessage(
      text: message,
      isUser: true,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    state = [...state, userMessage];

    try {
      final recipeService = ref.read(recipeServiceProvider);
      final aiResponse = await recipeService.sendAICookingChatMessage(message);
      final aiMessage = _AIChatMessage(
        text: aiResponse,
        isUser: false,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      state = [...state, aiMessage];
    } catch (e) {
      final errorMessage = _AIChatMessage(
        text:
            'Sorry, I couldn\'t process your request right now. Please try again.',
        isUser: false,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      state = [...state, errorMessage];
    }
  }

  void clearChat() {
    state = [];
  }
}

final recipeServiceProvider = Provider<RecipeService>((ref) => RecipeService());

class AIChatScreen extends HookConsumerWidget {
  const AIChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(aiChatProvider);
    final controller = useTextEditingController();
    final scrollController = useScrollController();
    final isLoading = useState(false);
    final showScrollToBottom = useState(false);
    final appProvider = ref.read(appControlProvider);
    final appProviderNotifier = ref.read(appControlProvider.notifier);
    final user = appProvider.user.asData?.value;
    useEffect(() {
      if (user == null) {
        Future.delayed(const Duration(milliseconds: 50), () {
          appProviderNotifier.setBottomNavbarIndex(3);
          Navigator.of(context).pushReplacementNamed(
            '/login',
            arguments: LoginScreenArguments(
              message: 'Please login to use ai features',
              screenToNavigate: '/ai-chat',
            ),
          );
        });
      }
      return () {};
    }, []);
    // Auto-scroll to bottom when messages change
    useEffect(() {
      if (scrollController.hasClients) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
        });
      }
      return null;
    }, [messages.length]);

    // Listen to scroll position for scroll-to-bottom button
    useEffect(() {
      void scrollListener() {
        if (scrollController.hasClients) {
          final isAtBottom = scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100;
          showScrollToBottom.value = !isAtBottom && messages.isNotEmpty;
        }
      }

      scrollController.addListener(scrollListener);
      return () => scrollController.removeListener(scrollListener);
    }, []);

    void send() {
      final text = controller.text.trim();
      if (text.isNotEmpty && !isLoading.value) {
        HapticFeedback.lightImpact();
        isLoading.value = true;
        ref.read(aiChatProvider.notifier).sendMessage(text).whenComplete(() {
          isLoading.value = false;
        });
        controller.clear();
      }
    }

    void scrollToBottom() {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    }

    void showClearDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Clear Chat'),
          content: const Text('Are you sure you want to clear all messages?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                ref.read(aiChatProvider.notifier).clearChat();
                Navigator.pop(context);
              },
              child: const Text('Clear'),
            ),
          ],
        ),
      );
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ColorfulSafeArea(
      color: colorScheme.surface,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: Column(
          children: [
            // Modern Glass-morphism AppBar
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface.withOpacity(0.95),
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outline.withOpacity(0.1),
                    width: 0.5,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: colorScheme.onSurface,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        style: IconButton.styleFrom(
                          backgroundColor:
                              colorScheme.surfaceVariant.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade400,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'AI Cooking Assistant',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Online • Ready to help',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (messages.isNotEmpty)
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                          onPressed: showClearDialog,
                          style: IconButton.styleFrom(
                            backgroundColor:
                                colorScheme.surfaceVariant.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Chat Messages
            Expanded(
              child: Stack(
                children: [
                  // Background with subtle pattern
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colorScheme.surface,
                          colorScheme.surfaceVariant.withOpacity(0.2),
                        ],
                      ),
                    ),
                  ),

                  // Messages List
                  messages.isEmpty
                      ? _EmptyState()
                      : ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                          itemCount:
                              messages.length + (isLoading.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Loading bubble
                            if (isLoading.value && index == messages.length) {
                              return _TypingBubble();
                            }

                            final msg = messages[index];
                            final isUser = msg.isUser;
                            final showAvatar = index == 0 ||
                                messages[index - 1].isUser != msg.isUser;

                            return _MessageBubble(
                              message: msg,
                              showAvatar: showAvatar,
                              isConsecutive: !showAvatar,
                            );
                          },
                        ),

                  // Scroll to bottom button
                  if (showScrollToBottom.value)
                    Positioned(
                      bottom: 100,
                      right: 16,
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(28),
                        child: InkWell(
                          onTap: scrollToBottom,
                          borderRadius: BorderRadius.circular(28),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: colorScheme.outline.withOpacity(0.1),
                              ),
                            ),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: colorScheme.onPrimaryContainer,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Modern Input Field
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface.withOpacity(0.95),
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outline.withOpacity(0.1),
                    width: 0.5,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceVariant.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: colorScheme.outline.withOpacity(0.1),
                            ),
                          ),
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: 'Ask me anything about cooking...',
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 16, 20, 16),
                              border: InputBorder.none,
                              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                            onSubmitted: (_) => send(),
                            minLines: 1,
                            maxLines: 4,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Material(
                        color: isLoading.value
                            ? colorScheme.outline.withOpacity(0.3)
                            : colorScheme.primary,
                        borderRadius: BorderRadius.circular(24),
                        child: InkWell(
                          onTap: isLoading.value ? null : send,
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: isLoading.value
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        colorScheme.onSurface.withOpacity(0.6),
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.arrow_upward_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Empty state widget
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_menu_rounded,
                size: 48,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Start a Conversation',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ask me about recipes, cooking tips, ingredients, or any culinary questions you have!',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _SuggestionChip('Recipe suggestions'),
                _SuggestionChip('Cooking techniques'),
                _SuggestionChip('Ingredient substitutes'),
                _SuggestionChip('Meal planning'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Suggestion chip widget
class _SuggestionChip extends StatelessWidget {
  final String label;

  const _SuggestionChip(this.label);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}

// Enhanced message bubble
class _MessageBubble extends StatelessWidget {
  final _AIChatMessage message;
  final bool showAvatar;
  final bool isConsecutive;

  const _MessageBubble({
    required this.message,
    required this.showAvatar,
    required this.isConsecutive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isUser = message.isUser;

    return Padding(
      padding: EdgeInsets.only(
        bottom: isConsecutive ? 2 : 12,
        top: isConsecutive ? 2 : 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser && showAvatar) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.smart_toy_rounded,
                size: 18,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 8),
          ] else if (!isUser) ...[
            const SizedBox(width: 40),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? colorScheme.primary : const Color(0xffe9eef6),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft:
                      Radius.circular(isUser ? 20 : (isConsecutive ? 20 : 4)),
                  bottomRight:
                      Radius.circular(isUser ? (isConsecutive ? 20 : 4) : 20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._buildMessageContent(
                      context, message, isUser, colorScheme, theme),
                  if (!isConsecutive) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(message.timestamp),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isUser
                            ? Colors.white.withOpacity(0.7)
                            : colorScheme.onSurface,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser && showAvatar) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.primary.withOpacity(0.2),
              child: Icon(
                Icons.person_rounded,
                size: 18,
                color: colorScheme.primary,
              ),
            ),
          ] else if (isUser) ...[
            const SizedBox(width: 40),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildMessageContent(
      BuildContext context,
      _AIChatMessage message,
      bool isUser,
      ColorScheme colorScheme,
      ThemeData theme) {
    // Only parse for AI messages
    if (isUser) {
      return [
        Text(
          message.text,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
      ];
    }
    // Split by ** for section headlines
    final regex = RegExp(r'\*\*(.*?)\*\*');
    final spans = <Widget>[];
    final text = message.text;
    int last = 0;
    for (final match in regex.allMatches(text)) {
      if (match.start > last) {
        final before = text.substring(last, match.start);
        if (before.trim().isNotEmpty) {
          spans.add(Text(
            before.trim(),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ));
        }
      }
      final headline = match.group(1)?.trim();
      if (headline != null && headline.isNotEmpty) {
        spans.add(Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(
            headline,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
      }
      last = match.end;
    }
    if (last < text.length) {
      final after = text.substring(last);
      if (after.trim().isNotEmpty) {
        spans.add(Text(
          after.trim(),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.black.withOpacity(0.8),
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ));
      }
    }
    return spans;
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${time.day}/${time.month}';
    }
  }
}

// Enhanced typing bubble with modern animation
class _TypingBubble extends StatefulWidget {
  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(
              Icons.smart_toy_rounded,
              size: 18,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 8),
          AnimatedBuilder(
            animation: _pulseAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xffe9eef6),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DotIndicator(controller: _controller, delay: 0),
                  const SizedBox(width: 4),
                  _DotIndicator(controller: _controller, delay: 0.2),
                  const SizedBox(width: 4),
                  _DotIndicator(controller: _controller, delay: 0.4),
                ],
              ),
            ),
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: child,
              );
            },
          ),
        ],
      ),
    );
  }
}

// Animated dot for typing indicator
class _DotIndicator extends StatelessWidget {
  final AnimationController controller;
  final double delay;

  const _DotIndicator({required this.controller, required this.delay});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final value = (controller.value - delay).clamp(0.0, 1.0);
        final opacity = (math.sin(value * math.pi * 2) + 1) / 2;

        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withOpacity(opacity * 0.6),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
