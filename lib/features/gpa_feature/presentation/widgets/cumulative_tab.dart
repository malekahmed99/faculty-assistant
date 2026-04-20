import 'package:ai_campus_guide/core/theme/app_colors.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/view/gpa_calculator_screen.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/widgets/action_button.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/widgets/add_button.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/widgets/college_rules_card.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/widgets/formula_card.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/widgets/result_card.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/widgets/semester_row.dart';
import 'package:ai_campus_guide/features/service_feature/logic/gpa_calculator.dart';
import 'package:flutter/material.dart';

class CumulativeTab extends StatelessWidget {
  final List<SemesterEntry> semesters;
  final double? result;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final void Function(int, SemesterEntry) onSemesterChanged;
  final VoidCallback onCalculate;
  final VoidCallback onReset;

  const CumulativeTab({super.key,
    required this.semesters,
    required this.result,
    required this.onAdd,
    required this.onRemove,
    required this.onSemesterChanged,
    required this.onCalculate,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── شرح المعادلة ─────────────────────────────────────────────────
        const SliverToBoxAdapter(
            child: FormulaCard(
          formulaAr: 'GPA التراكمي = Σ(GPA الفصل × ساعاته) ÷ Σ كل الساعات',
          formulaEn: 'Cumulative GPA = Σ(Sem.GPA × Hours) ÷ Σ All Hours',
        )),

        // ── قائمة الفصول ─────────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => SemesterRow(
                index: i,
                entry: semesters[i],
                onRemove: () => onRemove(i),
                onChanged: (s) => onSemesterChanged(i, s),
              ),
              childCount: semesters.length,
            ),
          ),
        ),

        // ── زر إضافة فصل ─────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AddButton(
              label: '+ Add Semester  /  أضف فصل',
              onTap: onAdd,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // ── أزرار الحساب والإعادة ─────────────────────────────────────────
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
            child: ResultCard(gpa: result!, isSemester: false),
          ),

        // ── قواعد الكلية ─────────────────────────────────────────────────
        const SliverToBoxAdapter(child: CollegeRulesCard()),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}
