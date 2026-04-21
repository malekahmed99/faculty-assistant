import 'package:ai_campus_guide/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CollegeRulesCard extends StatelessWidget {
  const CollegeRulesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.school_rounded, size: 16, color: AppColors.primary),
              SizedBox(width: 6),
              Text(
                'College Rules  /  قواعد الكلية',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _rule('🎓', 'Min. to Graduate', 'الحد الأدنى للتخرج',
              'GPA ≥ 2.00 out of 4.00'),
          _rule('🏆', 'Honor Roll', 'مرتبة الشرف',
              'GPA ≥ 3.60 — with extra conditions'),
          _rule('📚', 'Single Major', 'تخصص منفرد', '134 credit hours'),
          _rule('📚', 'Double Major', 'تخصص مزدوج', '140 credit hours'),
          _rule('☀️', 'Summer Semester', 'الفصل الصيفي',
              'Max 6 credit hours — optional'),
          _rule('🔄', 'Re-registration', 'إعادة التسجيل',
              'Last grade counts only  —  يُحسب التقدير الأخير فقط'),
        ],
      ),
    );
  }

  Widget _rule(String emoji, String en, String ar, String detail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$en  —  $ar',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                Text(detail,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
