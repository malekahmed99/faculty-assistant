import 'package:ai_campus_guide/core/theme/app_colors.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/view/gpa_calculator_screen.dart';
import 'package:ai_campus_guide/features/service_feature/data/model/service_item.dart';
import 'package:flutter/material.dart';

// ملاحظة: أُزيلت كلمة const من القايمة لأن onTap في كارت الـ GPA
// مش const — الـ 3 كاردات القديمة شغالة بالظبط زي ما كانت.

List<ServiceItem> buildServices(BuildContext context) => [
      const ServiceItem(
        icon: Icons.edit,
        title: 'Course Registration',
        subtitle: 'Add and drop courses',
        bgColor: Color(0xFFEEF2FF),
        borderColor: Color(0xFFC7D2FE),
        accentColor: AppColors.primary,
      ),
      const ServiceItem(
        icon: Icons.receipt,
        title: 'Request Transcript',
        subtitle: 'Official academic transcript',
        bgColor: Color(0xFFEDE9FE),
        borderColor: Color(0xFFDDD6FE),
        accentColor: AppColors.purple,
      ),
      const ServiceItem(
        icon: Icons.warning,
        title: 'Academic Warning',
        subtitle: 'Your current academic status',
        bgColor: Color(0xFFCCFBF1),
        borderColor: Color(0xFF99F6E4),
        accentColor: Colors.black,
      ),
      // ── كارت GPA الجديد ─────────────────────────────────────────────────────
      ServiceItem(
        icon: Icons.calculate_rounded,
        title: 'GPA Calculator',
        subtitle: 'حاسبة المعدل التراكمي',
        bgColor: const Color(0xFFFEF9C3),
        borderColor: const Color(0xFFFDE047),
        accentColor: const Color(0xFFCA8A04),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GpaCalculatorScreen()),
        ),
      ),
    ];
