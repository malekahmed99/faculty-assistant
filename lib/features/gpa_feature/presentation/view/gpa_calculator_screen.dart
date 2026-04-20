import 'package:ai_campus_guide/core/theme/app_colors.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/widgets/cumulative_tab.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/widgets/semester_tab.dart';
import 'package:ai_campus_guide/features/service_feature/data/model/gpa_course_model.dart';
import 'package:ai_campus_guide/features/service_feature/logic/gpa_calculator.dart';
import 'package:ai_campus_guide/features/service_feature/presentation/widgets/service_tab_bar.dart';
import 'package:flutter/material.dart';

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
            SemesterTab(
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
            CumulativeTab(
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
                    'Calculate your semester and cumulative GPA easily - Faculty of Science',
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
          child: ServiceTabBar(
            controller: _tabCtrl, tab1: 'Semester', tab2: 'Cumulative',
          )),
    );
  }
}
