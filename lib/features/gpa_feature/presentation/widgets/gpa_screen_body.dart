import 'package:ai_campus_guide/core/theme/app_colors.dart';
import 'package:ai_campus_guide/features/gpa_feature/data/cubit/gpa_cubit.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/widgets/cumulative_tab.dart';
import 'package:ai_campus_guide/features/gpa_feature/presentation/widgets/semester_tab.dart';
import 'package:ai_campus_guide/features/service_feature/presentation/widgets/service_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GpaScreenBody extends StatefulWidget {
  const GpaScreenBody({super.key});

  @override
  State<GpaScreenBody> createState() => _GpaScreenBodyState();
}

class _GpaScreenBodyState extends State<GpaScreenBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface2,
      body: NestedScrollView(
        headerSliverBuilder: (_, isScrolled) => [
          _buildAppBar(isScrolled),
        ],
        body: BlocBuilder<GpaCubit, GpaState>(
          builder: (context, state) {
            final cubit = context.read<GpaCubit>();

            return TabBarView(
              controller: _tabCtrl,
              children: [
                SemesterTab(
                  courses: state.courses,
                  result: state.semesterResult,
                  onAdd: cubit.addCourse,
                  onRemove: cubit.removeCourse,
                  onCourseChanged: cubit.updateCourse,
                  onCalculate: cubit.calcSemester,
                  onReset: cubit.resetSemester,
                ),
                CumulativeTab(
                  semesters: state.semesters,
                  result: state.cumulativeResult,
                  onAdd: cubit.addSemester,
                  onRemove: cubit.removeSemester,
                  onSemesterChanged: cubit.updateSemester,
                  onCalculate: cubit.calcCumulative,
                  onReset: cubit.resetCumulative,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(bool elevated) {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      forceElevated: elevated,
      backgroundColor: AppColors.primaryDark,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B4FCC), Color(0xFF1338A8)],
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.fromLTRB(24, 60, 24, 20),
            child: Text(
              'GPA Calculator',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: ServiceTabBar(
          controller: _tabCtrl,
          tab1: 'Semester',
          tab2: 'Cumulative',
        ),
      ),
    );
  }
}
