import 'package:flutter/foundation.dart';
import '../models/ai_response.dart';
import '../models/location_model.dart';

class AiService {
  final List<LocationModel> _locations;
  final String? _openAiApiKey;
  bool get _useOpenAI => _openAiApiKey != null && _openAiApiKey!.isNotEmpty;

  AiService(this._locations, [this._openAiApiKey]);

  Future<AiResponse> getResponse(String userQuestion) async {
    if (_useOpenAI) {
      return await _getOpenAIResponse(userQuestion);
    } else {
      return _getLocalResponse(userQuestion);
    }
  }

  Future<AiResponse> _getOpenAIResponse(String question) async {
    try {
      // Note: In production, you'd use the openai package
      // For now, fallback to local matching
      return _getLocalResponse(question);
    } catch (e) {
      if (kDebugMode) {
        print('OpenAI API error: $e');
      }
      return _getLocalResponse(question);
    }
  }

  AiResponse _getLocalResponse(String question) {
    final lowerQuestion = question.toLowerCase();
    
    // Find best matching location
    LocationModel? bestMatch;
    double bestScore = 0.0;

    for (final location in _locations) {
      final score = _calculateMatchScore(lowerQuestion, location);
      if (score > bestScore) {
        bestScore = score;
        bestMatch = location;
      }
    }

    // Generate response
    String answer;
    if (bestMatch != null && bestScore > 0.3) {
      answer = _generateAnswer(bestMatch, lowerQuestion);
    } else {
      answer = _generateGeneralAnswer(lowerQuestion);
    }

    return AiResponse(
      answer: answer,
      suggestedLocationId: bestMatch?.id,
    );
  }

  double _calculateMatchScore(String question, LocationModel location) {
    double score = 0.0;
    final nameLower = location.name.toLowerCase();
    final categoryLower = location.category.toLowerCase();
    final buildingLower = location.building.toLowerCase();
    final descLower = location.description.toLowerCase();

    // Direct name match
    if (question.contains(nameLower)) {
      score += 0.8;
    }

    // Category match
    if (question.contains(categoryLower)) {
      score += 0.5;
    }

    // Building match
    if (question.contains(buildingLower)) {
      score += 0.4;
    }

    // Description match (keywords)
    final keywords = _extractKeywords(question);
    for (final keyword in keywords) {
      if (nameLower.contains(keyword)) score += 0.3;
      if (descLower.contains(keyword)) score += 0.2;
      if (categoryLower.contains(keyword)) score += 0.2;
    }

    // Location type keywords
    if (_matchLocationType(question, location)) {
      score += 0.4;
    }

    return score.clamp(0.0, 1.0);
  }

  List<String> _extractKeywords(String text) {
    final commonWords = {
      'where', 'how', 'what', 'can', 'find', 'get', 'the', 'a', 'an',
      'is', 'are', 'was', 'were', 'in', 'on', 'at', 'to', 'for',
      'of', 'with', 'by', 'from', 'i', 'you', 'we', 'they', 'it'
    };
    
    return text
        .split(RegExp(r'\s+'))
        .where((word) => word.length > 2 && !commonWords.contains(word))
        .toList();
  }

  bool _matchLocationType(String question, LocationModel location) {
    final typeKeywords = {
      'library': ['library', 'book', 'study', 'reading'],
      'cafeteria': ['cafeteria', 'food', 'eat', 'restaurant', 'cafe', 'coffee', 'lunch', 'breakfast'],
      'office': ['office', 'administration', 'admin'],
      'lab': ['lab', 'laboratory', 'computer', 'research'],
      'department': ['department', 'faculty', 'professor'],
      'auditorium': ['auditorium', 'hall', 'audience', 'lecture', 'event'],
      'registration': ['registration', 'enroll', 'enrollment', 'register'],
      'student affairs': ['student affairs', 'student services', 'complaint'],
      'it support': ['it', 'tech', 'support', 'computer help', 'wifi', 'internet'],
    };

    final categoryLower = location.category.toLowerCase();
    final nameLower = location.name.toLowerCase();

    for (final entry in typeKeywords.entries) {
      if (entry.key == categoryLower || entry.key == nameLower) {
        for (final keyword in entry.value) {
          if (question.contains(keyword)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  String _generateAnswer(LocationModel location, String question) {
    final directions = question.contains('how to') || question.contains('directions') || question.contains('reach');
    
    String answer = '';
    
    if (directions) {
      answer = 'You can find ${location.name} in the ${location.building} building, ${location.floor}. ';
      answer += 'It\'s located at coordinates (${location.lat.toStringAsFixed(4)}, ${location.lng.toStringAsFixed(4)}). ';
    } else {
      answer = '${location.name} is a ${location.category.toLowerCase()} location. ';
      answer += 'It\'s in the ${location.building} building, ${location.floor}. ';
    }

    if (location.openingHours.isNotEmpty) {
      answer += 'Operating hours: ${location.openingHours}. ';
    }

    if (location.contactInfo.isNotEmpty) {
      answer += 'Contact: ${location.contactInfo}.';
    }

    answer += '\n\nWould you like me to show you on the map?';
    
    return answer;
  }

  String _generateGeneralAnswer(String question) {
    if (question.contains('hello') || question.contains('hi') || question.contains('hey')) {
      return 'Hello! I\'m your AI Campus Guide. I can help you find locations, get directions, and answer questions about the Faculty of Science campus. What would you like to know?';
    }

    if (question.contains('help')) {
      return 'I can help you with:\n\n• Finding specific locations (e.g., "Where is the library?")\n• Getting directions to places\n• Information about campus services\n• Operating hours of facilities\n• Contact information\n\nJust ask me a question!';
    }

    if (question.contains('hours') || question.contains('open') || question.contains('time')) {
      return 'Most campus locations operate from Sunday to Thursday, typically from 9:00 AM to 3:00 PM. However, specific hours may vary. Which location would you like to know about?';
    }

    if (question.contains('map')) {
      return 'I can show you locations on the map! Just ask me to find a specific place, and I\'ll guide you there. Would you like to explore the campus map?';
    }

    return 'I\'m not sure I understand. Could you please rephrase your question? For example:\n\n• "Where is the library?"\n• "How can I reach the cafeteria?"\n• "What are the computer lab hours?"\n\nOr ask for help!';
  }

  // Get location by ID from cached list
  LocationModel? getLocationById(String id) {
    try {
      return _locations.firstWhere((loc) => loc.id == id);
    } catch (e) {
      return null;
    }
  }
}

