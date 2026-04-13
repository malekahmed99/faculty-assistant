import 'package:flutter/material.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.22),
            width: 1.5),
      ),
      child: TextField(
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          fillColor: Colors.transparent,
          hintText: 'Search for places, services...',
          hintStyle: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.55),
          ),
          prefixIcon: Icon(Icons.search,
              size: 16,
              color: Colors.white.withValues(alpha: 0.7)),
        ),
      ),
    );
  }
}
