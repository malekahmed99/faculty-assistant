import 'package:ai_campus_guide/core/theme/app_colors.dart';
import 'package:ai_campus_guide/core/utils/custom_button.dart';
import 'package:flutter/material.dart';

class GpaActionButtons extends StatelessWidget {
  const GpaActionButtons({
    super.key,
    required this.onCalculate,
    required this.onReset,
  });

  final VoidCallback onCalculate;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
                child: CustomButton(
                    text: 'Calculate',
                    backgroundColor: AppColors.primary,
                    onTap: onCalculate)),
            const SizedBox(width: 10),
            Expanded(
              child: CustomButton(
                  onTap: onReset,
                  text: 'Reset',
                  backgroundColor: AppColors.textSecondary),
            )
          ],
        ),
      ),
    );
  }
}
