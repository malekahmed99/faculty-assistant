import 'package:flutter/material.dart';

class WelcomeSectionHomeScreen extends StatelessWidget {
  const WelcomeSectionHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.65),
          ),
        ),
        const SizedBox(height: 3),

        // title
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.2,
            ),
            children: [
              TextSpan(text: 'Campus Guide\n'),
              TextSpan(
                text: 'Sciences',
                style: TextStyle(color: Color(0xFF93C5FD)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // subtitle
        Text(
          'University of Ain Shams — Everything you need in one place',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
