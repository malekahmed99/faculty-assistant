class AiResponse {
  final String answer;
  final String? suggestedLocationId;

  AiResponse({
    required this.answer,
    this.suggestedLocationId,
  });

  factory AiResponse.fromMap(Map<String, dynamic> map) {
    return AiResponse(
      answer: map['answer'] ?? '',
      suggestedLocationId: map['suggestedLocationId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
      'suggestedLocationId': suggestedLocationId,
    };
  }

  bool get hasSuggestion => suggestedLocationId != null;

  @override
  String toString() {
    return 'AiResponse(answer: ${answer.substring(0, answer.length > 30 ? 30 : answer.length)}..., suggestedLocationId: $suggestedLocationId)';
  }
}

