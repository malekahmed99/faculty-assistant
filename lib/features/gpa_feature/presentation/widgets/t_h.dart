import 'package:ai_campus_guide/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TH extends StatelessWidget {
  final String text;
  const TH(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: 0.3));
  }
}
