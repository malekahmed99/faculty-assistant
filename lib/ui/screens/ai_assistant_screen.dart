import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/locations_provider.dart';
import '../../providers/chat_provider.dart';
import '../../models/chat_message_model.dart';
import '../widgets/chat_bubble.dart';
import 'location_details_screen.dart';
import 'map_screen.dart';

class AiAssistantScreen extends ConsumerStatefulWidget {
  final String? initialMessage;

  const AiAssistantScreen({super.key, this.initialMessage});

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Send initial message if provided
    if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendMessage(widget.initialMessage!);
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // final locations = await ref.read(locationsProvider.future);

    // Add user message
    final userMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      sender: MessageSender.user,
      createdAt: DateTime.now(),
    );

    ref.read(chatProvider.notifier).update((state) => [...state, userMessage]);
    _messageController.clear();

    setState(() => _isLoading = true);
    _scrollToBottom();

    // Simulate AI thinking
    await Future.delayed(const Duration(milliseconds: 500));

    // Get AI response using local matching
    final aiService = ref.read(aiServiceProvider);
    await ref.read(chatProvider.notifier).addAiMessage(text.trim(), aiService);
    // final response = await aiService.getResponse(text.trim());

    // // Add AI message
    // final aiMessage = ChatMessageModel(
    //   id: DateTime.now().millisecondsSinceEpoch.toString(),
    //   text: response.answer,
    //   sender: MessageSender.ai,
    //   createdAt: DateTime.now(),
    //   suggestedLocationId: response.suggestedLocationId,
    // );

    // ref.read(chatProvider.notifier).update((state) => [...state, aiMessage]);

    setState(() => _isLoading = false);
    _scrollToBottom();
  }

  void _openLocationDetails(String locationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LocationDetailsScreen(locationId: locationId),
      ),
    );
  }

  void _openOnMap(String locationId) async {
    final location = await ref.read(locationByIdProvider(locationId).future);
    if (location != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MapScreen(focusLocation: location),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Campus Guide'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              ref.read(chatProvider.notifier).update((state) => []);
            },
            tooltip: 'Clear chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Welcome message if no messages
          if (messages.isEmpty)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.smart_toy,
                          size: 50,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Hello! I\'m your AI Campus Guide',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Ask me anything about the Faculty of Science campus. I can help you find locations, get directions, and answer your questions.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      // Suggested questions
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildSuggestionChip('Where is the library?'),
                          _buildSuggestionChip('Computer lab hours'),
                          _buildSuggestionChip('Student affairs office'),
                          _buildSuggestionChip('Cafeteria location'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            // Messages list
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return ChatBubble(
                    message: message,
                    onOpenDetails: message.hasSuggestion
                        ? () =>
                            _openLocationDetails(message.suggestedLocationId!)
                        : null,
                    onOpenMap: message.hasSuggestion
                        ? () => _openOnMap(message.suggestedLocationId!)
                        : null,
                  );
                },
              ),
            ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask me anything...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) => _sendMessage(value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.send, color: Colors.white),
                      onPressed: _isLoading
                          ? null
                          : () => _sendMessage(_messageController.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () => _sendMessage(text),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      labelStyle: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
