import 'package:ai_campus_guide/features/home_feature/presentation/widgets/decoration_backgroung_stack_home_screen.dart';
import 'package:ai_campus_guide/features/home_feature/presentation/widgets/welcome_section_home_screen.dart';
import 'package:flutter/material.dart';

class ServicesHeader extends StatelessWidget {
  const ServicesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.55, 1.0],
          colors: [Color(0xFF1B4FCC), Color(0xFF1338A8), Color(0xFF0D2680)],
        ),
      ),
      child: const Stack(
        children: [
          DecorationBackgroungStackHomeScreen(),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 56),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CustomHomeAppBar(blinkAnim: blinkAnim),
                  WelcomeSectionHomeScreen(
                    tileName: 'Student',
                    subTitle: 'Affairs',
                    description: 'Every service you need in one place',
                  ),
                  // const SearchSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
