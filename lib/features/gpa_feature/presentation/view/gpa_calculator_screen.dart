import 'package:ai_campus_guide/core/theme/app_colors.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/widgets/gpa_course_row.dart';
import 'package:ai_campus_guide/features/service_feature/data/model/gpa_course_model.dart';
import 'package:ai_campus_guide/features/service_feature/logic/gpa_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GpaCalculatorScreen extends StatefulWidget {
  const GpaCalculatorScreen({super.key});

  @override
  State<GpaCalculatorScreen> createState() => _GpaCalculatorScreenState();
}

class _GpaCalculatorScreenState extends State<GpaCalculatorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  final List<GpaCourse> _courses = [GpaCourse(), GpaCourse(), GpaCourse()];
  double? _semResult;

  final List<SemesterEntry> _semesters = [
    SemesterEntry(),
    SemesterEntry(),
    SemesterEntry(),
  ];
  double? _cumResult;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  // ── Semester helpers ──────────────────────────────────────────────────────
  void _calcSemester() {
    setState(() => _semResult = calcSemesterGPA(_courses));
  }

  void _addCourse() {
    setState(() => _courses.add(GpaCourse()));
  }

  void _removeCourse(int i) {
    if (_courses.length <= 1) return;
    setState(() {
      _courses.removeAt(i);
      _semResult = null;
    });
  }

  void _resetSemester() {
    setState(() {
      _courses
        ..clear()
        ..addAll([GpaCourse(), GpaCourse(), GpaCourse()]);
      _semResult = null;
    });
  }

  // ── Cumulative helpers ────────────────────────────────────────────────────
  void _calcCumulative() {
    setState(() => _cumResult = calcCumulativeGPA(_semesters));
  }

  void _addSemester() {
    setState(() => _semesters.add(SemesterEntry()));
  }

  void _removeSemester(int i) {
    if (_semesters.length <= 1) return;
    setState(() {
      _semesters.removeAt(i);
      _cumResult = null;
    });
  }

  void _resetCumulative() {
    setState(() {
      _semesters
        ..clear()
        ..addAll([SemesterEntry(), SemesterEntry(), SemesterEntry()]);
      _cumResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface2,
      body: NestedScrollView(
        headerSliverBuilder: (_, innerBoxIsScrolled) => [
          _buildAppBar(innerBoxIsScrolled),
        ],
        body: TabBarView(
          controller: _tabCtrl,
          children: [
            _SemesterTab(
              courses: _courses,
              result: _semResult,
              onAdd: _addCourse,
              onRemove: _removeCourse,
              onCourseChanged: (i, c) => setState(() {
                _courses[i] = c;
                _semResult = null;
              }),
              onCalculate: _calcSemester,
              onReset: _resetSemester,
            ),
            _CumulativeTab(
              semesters: _semesters,
              result: _cumResult,
              onAdd: _addSemester,
              onRemove: _removeSemester,
              onSemesterChanged: (i, s) => setState(() {
                _semesters[i] = s;
                _cumResult = null;
              }),
              onCalculate: _calcCumulative,
              onReset: _resetCumulative,
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(bool forceElevated) {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      floating: false,
      forceElevated: forceElevated,
      backgroundColor: AppColors.primaryDark,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1B4FCC), Color(0xFF1338A8), Color(0xFF0D2680)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'GPA Calculator',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'حاسبة المعدل التراكمي — كلية العلوم',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          color: AppColors.primaryDark,
          child: TabBar(
            controller: _tabCtrl,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
            labelStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            unselectedLabelStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            tabs: const [
              Tab(text: 'Semester  /  الفصل'),
              Tab(text: 'Cumulative  /  التراكمي'),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  TAB 1 — Semester GPA
// ════════════════════════════════════════════════════════════════════════════
class _SemesterTab extends StatelessWidget {
  final List<GpaCourse> courses;
  final double? result;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final void Function(int, GpaCourse) onCourseChanged;
  final VoidCallback onCalculate;
  final VoidCallback onReset;

  const _SemesterTab({
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
        SliverToBoxAdapter(
            child: _FormulaCard(
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
            child: _AddButton(
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
                  child: _ActionButton(
                    label: 'Calculate  /  احسب',
                    icon: Icons.calculate_rounded,
                    color: AppColors.primary,
                    onTap: onCalculate,
                  ),
                ),
                const SizedBox(width: 10),
                _ActionButton(
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
            child: _ResultCard(gpa: result!, isSemester: true),
          ),

        // ── جدول التقديرات ───────────────────────────────────────────────
        const SliverToBoxAdapter(child: _GradeTable()),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  TAB 2 — Cumulative GPA
// ════════════════════════════════════════════════════════════════════════════
class _CumulativeTab extends StatelessWidget {
  final List<SemesterEntry> semesters;
  final double? result;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final void Function(int, SemesterEntry) onSemesterChanged;
  final VoidCallback onCalculate;
  final VoidCallback onReset;

  const _CumulativeTab({
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
        SliverToBoxAdapter(
            child: _FormulaCard(
          formulaAr: 'GPA التراكمي = Σ(GPA الفصل × ساعاته) ÷ Σ كل الساعات',
          formulaEn: 'Cumulative GPA = Σ(Sem.GPA × Hours) ÷ Σ All Hours',
        )),

        // ── قائمة الفصول ─────────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => _SemesterRow(
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
            child: _AddButton(
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
                  child: _ActionButton(
                    label: 'Calculate  /  احسب',
                    icon: Icons.calculate_rounded,
                    color: AppColors.primary,
                    onTap: onCalculate,
                  ),
                ),
                const SizedBox(width: 10),
                _ActionButton(
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
            child: _ResultCard(gpa: result!, isSemester: false),
          ),

        // ── قواعد الكلية ─────────────────────────────────────────────────
        const SliverToBoxAdapter(child: _CollegeRulesCard()),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  صف فصل دراسي — Cumulative tab
// ════════════════════════════════════════════════════════════════════════════
class _SemesterRow extends StatelessWidget {
  final int index;
  final SemesterEntry entry;
  final VoidCallback onRemove;
  final ValueChanged<SemesterEntry> onChanged;

  const _SemesterRow({
    required this.index,
    required this.entry,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Semester ${index + 1}  •  الفصل ${index + 1}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textTertiary,
                ),
              ),
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.redLight,
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: AppColors.red.withValues(alpha: 0.3)),
                  ),
                  child:
                      const Icon(Icons.close, size: 14, color: AppColors.red),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // GPA الفصل
              Expanded(
                child: _numField(
                  hint: 'Semester GPA  /  معدل الفصل',
                  initial: entry.gpa.toStringAsFixed(2),
                  onChanged: (v) {
                    final parsed = double.tryParse(v);
                    if (parsed != null && parsed >= 0 && parsed <= 4) {
                      onChanged(SemesterEntry(gpa: parsed, hours: entry.hours));
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              // الساعات
              Expanded(
                child: _numField(
                  hint: 'Hours  /  ساعات',
                  initial: entry.hours.toStringAsFixed(0),
                  onChanged: (v) {
                    final parsed = double.tryParse(v);
                    if (parsed != null && parsed > 0) {
                      onChanged(SemesterEntry(gpa: entry.gpa, hours: parsed));
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _numField({
    required String hint,
    required String initial,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      initialValue: initial,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
      ],
      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
        filled: true,
        fillColor: AppColors.surface2,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      onChanged: onChanged,
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  بطاقة النتيجة
// ════════════════════════════════════════════════════════════════════════════
class _ResultCard extends StatelessWidget {
  final double gpa;
  final bool isSemester;

  const _ResultCard({required this.gpa, required this.isSemester});

  @override
  Widget build(BuildContext context) {
    final status = getAcademicStatus(gpa);

    Color cardColor;
    Color borderColor;
    if (gpa >= 3.60) {
      cardColor = AppColors.greenLight;
      borderColor = AppColors.green;
    } else if (gpa >= 3.00) {
      cardColor = AppColors.primaryLight;
      borderColor = AppColors.primary;
    } else if (gpa >= 2.00) {
      cardColor = AppColors.amberLight;
      borderColor = AppColors.amber;
    } else {
      cardColor = AppColors.redLight;
      borderColor = AppColors.red;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // الإيموجي والـ GPA
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(status.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gpa.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: borderColor,
                      height: 1,
                    ),
                  ),
                  Text(
                    'out of 4.00  /  من 4.00',
                    style: TextStyle(
                      fontSize: 11,
                      color: borderColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: borderColor.withValues(alpha: 0.25)),
          const SizedBox(height: 10),

          // المستوى
          Text(
            '${status.emoji}  ${status.labelEn}  —  ${status.labelAr}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: borderColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),

          // هل يحق التخرج (فقط في التراكمي)
          if (!isSemester)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: status.canGraduate
                    ? AppColors.greenLight
                    : AppColors.redLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: status.canGraduate ? AppColors.green : AppColors.red,
                ),
              ),
              child: Text(
                status.canGraduate
                    ? '✅  Eligible to Graduate  —  يحق له التخرج'
                    : '⚠️  Not Eligible to Graduate  —  لا يحق له التخرج',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: status.canGraduate ? AppColors.green : AppColors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  بطاقة المعادلة
// ════════════════════════════════════════════════════════════════════════════
class _FormulaCard extends StatelessWidget {
  final String formulaAr;
  final String formulaEn;

  const _FormulaCard({required this.formulaAr, required this.formulaEn});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.functions_rounded, size: 16, color: AppColors.primary),
              SizedBox(width: 6),
              Text(
                'Formula  /  المعادلة',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formulaEn,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 3),
          Text(
            formulaAr,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  جدول التقديرات (يظهر في تاب الفصل)
// ════════════════════════════════════════════════════════════════════════════
class _GradeTable extends StatelessWidget {
  const _GradeTable();

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
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              children: [
                const Icon(Icons.table_chart_rounded,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  'Grade Table  /  جدول التقديرات',
                  style: const TextStyle(
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
                Expanded(flex: 1, child: _TH('Grade')),
                Expanded(flex: 1, child: _TH('Points')),
                Expanded(flex: 2, child: _TH('Arabic')),
                Expanded(flex: 2, child: _TH('Range')),
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

class _TH extends StatelessWidget {
  final String text;
  const _TH(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: 0.3));
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  قواعد الكلية (يظهر في تاب التراكمي)
// ════════════════════════════════════════════════════════════════════════════
class _CollegeRulesCard extends StatelessWidget {
  const _CollegeRulesCard();

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

// ════════════════════════════════════════════════════════════════════════════
//  زر إضافة
// ════════════════════════════════════════════════════════════════════════════
class _AddButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _AddButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.35),
              style: BorderStyle.solid),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  زر الأكشن (احسب / Reset)
// ════════════════════════════════════════════════════════════════════════════
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool small;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: small ? 14 : 0, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
