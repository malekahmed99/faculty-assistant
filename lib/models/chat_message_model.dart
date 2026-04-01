enum MessageSender { user, ai }

class ChatMessageModel {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime createdAt;
  final String? suggestedLocationId;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.sender,
    required this.createdAt,
    this.suggestedLocationId,
  });

  factory ChatMessageModel.fromMap(Map<String, dynamic> map, String id) {
    return ChatMessageModel(
      id: id,
      text: map['text'] ?? '',
      sender: map['sender'] == 'user' ? MessageSender.user : MessageSender.ai,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      suggestedLocationId: map['suggestedLocationId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'sender': sender == MessageSender.user ? 'user' : 'ai',
      'createdAt': createdAt.toIso8601String(),
      'suggestedLocationId': suggestedLocationId,
    };
  }

  bool get hasSuggestion => suggestedLocationId != null;

  @override
  String toString() {
    return 'ChatMessageModel(id: $id, sender: $sender, text: ${text.substring(0, text.length > 20 ? 20 : text.length)}...)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessageModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

