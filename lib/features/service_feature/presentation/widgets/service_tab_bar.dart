import 'package:ai_campus_guide/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ServiceTabBar extends StatelessWidget {
  final TabController controller;
  const ServiceTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDark,
      child: TabBar(
        controller: controller,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Services'),
          Tab(text: 'FAQ'),
        ],
      ),
    );
  }
}
