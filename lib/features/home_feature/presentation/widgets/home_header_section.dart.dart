import 'package:ai_campus_guide/features/home_feature/presentation/widgets/custom_home_app_bar.dart';
import 'package:ai_campus_guide/features/home_feature/presentation/widgets/decoration_backgroung_stack_home_screen.dart';
import 'package:ai_campus_guide/features/home_feature/presentation/widgets/search_section.dart';
import 'package:ai_campus_guide/features/home_feature/presentation/widgets/welcome_section_home_screen.dart';
import 'package:flutter/material.dart';

class HomeHeaderSection extends StatelessWidget {
  final Animation<double> blinkAnim;
  const HomeHeaderSection({super.key, required this.blinkAnim});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.55, 1.0],
          colors: [Color(0xFF1B4FCC), Color(0xFF1338A8), Color(0xFF0D2680)],
        ),
      ),
      child: Stack(
        children: [
          const DecorationBackgroungStackHomeScreen(),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 56),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomHomeAppBar(blinkAnim: blinkAnim),
                  const SizedBox(height: 20),
                  const WelcomeSectionHomeScreen(),
                  const SizedBox(height: 18),
                  const SearchSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
