import 'package:ai_campus_guide/core/theme/app_colors.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/view/gpa_calculator_screen.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/widgets/t_h.dart';
import 'package:flutter/material.dart';

class GradeTable extends StatelessWidget {
  const GradeTable({super.key});

  static const _rows = [
    ('A', '4.00', 'ممتاز', '≥ 90%'),
    ('A-', '3.67', 'ممتاز ناقص', '85–90%'),
    ('B+', '3.33', 'جيد جداً +', '80–85%'),
    ('B', '3.00', 'جيد جداً', '75–80%'),
    ('C+', '2.67', 'جيد +', '70–75%'),
    ('C', '2.33', 'جيد', '65–70%'),
    ('D', '2.00', 'مقبول', '60–65%'),
    ('F', '0.00', 'راسب', '< 60%'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              children: [
                Icon(Icons.table_chart_rounded,
                    size: 16, color: AppColors.primary),
                SizedBox(width: 6),
                Text(
                  'Grade Table  /  جدول التقديرات',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          // header row
          Container(
            color: AppColors.primaryLight,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: const Row(
              children: [
                Expanded(flex: 1, child: TH('Grade')),
                Expanded(flex: 1, child: TH('Points')),
                Expanded(flex: 2, child: TH('Arabic')),
                Expanded(flex: 2, child: TH('Range')),
              ],
            ),
          ),
          ..._rows.asMap().entries.map((e) {
            final isEven = e.key.isEven;
            final r = e.value;
            return Container(
              color: isEven ? Colors.transparent : AppColors.surface2,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(r.$1,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(r.$2,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(r.$3,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondary),
                        textDirection: TextDirection.rtl),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(r.$4,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textTertiary)),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
