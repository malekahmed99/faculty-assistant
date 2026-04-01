import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message_model.dart';
// import '../models/ai_response.dart';
// import '../models/location_model.dart';
import '../services/ai_service.dart';
import '../providers/locations_provider.dart';

// // Firebase service provider
// final firebaseServiceProvider = Provider<FirebaseService>((ref) {
//   return FirebaseService.instance;
// });

// AI Service provider - using Provider to get AiService synchronously
final aiServiceProvider = Provider<AiService>((ref) {
  final locationsAsync = ref.watch(locationsProvider);
  return locationsAsync.maybeWhen(
    data: (locations) => AiService(locations),
    orElse: () => AiService([]),
  );
});

// Chat messages state
class ChatNotifier extends StateNotifier<List<ChatMessageModel>> {
  // final AiService _aiService;
  // final List<LocationModel> _locations;

  ChatNotifier() : super([]);

  // void addUserMessage(String text) {
  //   final userMessage = ChatMessageModel(
  //     id: DateTime.now().millisecondsSinceEpoch.toString(),
  //     text: text,
  //     sender: MessageSender.user,
  //     createdAt: DateTime.now(),
  //   );
  //   state = [...state, userMessage];
  // }

  Future<void> addAiMessage(String userQuestion, AiService aiService) async {
    // Create AI service with current locations
    // final aiService = AiService(_locations);

    // Show typing indicator
    final typingId = 'typing_${DateTime.now().millisecondsSinceEpoch}';
    final typingMessage = ChatMessageModel(
      id: typingId,
      text: 'Thinking...',
      sender: MessageSender.ai,
      createdAt: DateTime.now(),
    );
    state = [...state, typingMessage];

    // Get AI response
    final response = await aiService.getResponse(userQuestion);

    // Remove typing message and add actual response
    final aiMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: response.answer,
      sender: MessageSender.ai,
      createdAt: DateTime.now(),
      suggestedLocationId: response.suggestedLocationId,
    );

    state = [...state.where((m) => m.id != typingMessage.id), aiMessage];
  }

  void clearChat() {
    state = [];
  }

  // Update method for state manipulation (used by UI)
  void update(List<ChatMessageModel> Function(List<ChatMessageModel>) updater) {
    state = updater(state);
  }

  // void updateLocations(List<LocationModel> locations) {
  //   // Update internal locations list
  // }
}

// Chat provider
final chatProvider =
    StateNotifierProvider<ChatNotifier, List<ChatMessageModel>>((ref) {
  return ChatNotifier();
});

// Chat input provider
final chatInputProvider = StateProvider<String>((ref) => '');

// Is loading provider
final isTypingProvider = Provider<bool>((ref) {
  final messages = ref.watch(chatProvider);
  return messages.any(
    (m) => m.text == 'Thinking...' && m.sender == MessageSender.ai,
  );
});
