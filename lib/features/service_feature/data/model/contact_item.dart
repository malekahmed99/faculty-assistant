import 'package:flutter/material.dart';

class ContactItem {
  final String emoji;
  final String label;
  final String value;
  final String actionLabel;
  final Color color;
 
  const ContactItem({
    required this.emoji,
    required this.label,
    required this.value,
    required this.actionLabel,
    required this.color,
  });
}