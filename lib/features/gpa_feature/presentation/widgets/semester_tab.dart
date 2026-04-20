import 'package:ai_campus_guide/core/theme/app_colors.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/widgets/action_button.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/widgets/add_button.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/widgets/formula_card.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/widgets/gpa_course_row.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/widgets/grade_table.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/widgets/result_card.dart';
import 'package:ai_campus_guide/features/service_feature/data/model/gpa_course_model.dart';
import 'package:flutter/material.dart';

class SemesterTab extends StatelessWidget {
  final List<GpaCourse> courses;
  final double? result;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final void Function(int, GpaCourse) onCourseChanged;
  final VoidCallback onCalculate;
  final VoidCallback onReset;

  const SemesterTab({
    super.key,
    required this.courses,
    required this.result,
    required this.onAdd,
    required this.onRemove,
    required this.onCourseChanged,
    required this.onCalculate,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── شرح المعادلة ────────────────────────────────────────────────
        const SliverToBoxAdapter(
            child: FormulaCard(
          formulaAr: 'GPA الفصل = Σ(نقاط × ساعات) ÷ Σ ساعات',
          formulaEn: 'Semester GPA = Σ(Points × Hours) ÷ Σ Hours',
        )),

        // ── قائمة الكورسات ───────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => GpaCourseRow(
                index: i,
                course: courses[i],
                onRemove: () => onRemove(i),
                onChanged: (c) => onCourseChanged(i, c),
              ),
              childCount: courses.length,
            ),
          ),
        ),

        // ── زر إضافة كورس ───────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AddButton(
              label: '+ Add Course  /  أضف مقرر',
              onTap: onAdd,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // ── أزرار الحساب والإعادة ────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ActionButton(
                    label: 'Calculate  /  احسب',
                    icon: Icons.calculate_rounded,
                    color: AppColors.primary,
                    onTap: onCalculate,
                  ),
                ),
                const SizedBox(width: 10),
                ActionButton(
                  label: 'Reset',
                  icon: Icons.refresh_rounded,
                  color: AppColors.textSecondary,
                  onTap: onReset,
                  small: true,
                ),
              ],
            ),
          ),
        ),

        // ── النتيجة ──────────────────────────────────────────────────────
        if (result != null)
          SliverToBoxAdapter(
            child: ResultCard(gpa: result!, isSemester: true),
          ),

        // ── جدول التقديرات ───────────────────────────────────────────────
        const SliverToBoxAdapter(child: GradeTable()),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}
