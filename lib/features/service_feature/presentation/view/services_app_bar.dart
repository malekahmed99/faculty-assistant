import 'package:ai_campus_guide/core/theme/app_colors.dart';
import 'package:ai_campus_guide/features/service_feature/presentation/view/service_tab_bar.dart';
import 'package:ai_campus_guide/features/service_feature/presentation/widgets/services_header.dart';
import 'package:flutter/material.dart';

class ServicesAppBar extends StatelessWidget {
  final TabController tabController;
  final bool forceElevated;
  const ServicesAppBar({super.key, 
    required this.tabController,
    required this.forceElevated,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      floating: false,
      forceElevated: forceElevated,
      backgroundColor: AppColors.primaryDark,
      leading: const SizedBox.shrink(),
      flexibleSpace: const FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: ServicesHeader(),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(52),
        child: ServiceTabBar(controller: tabController),
      ),
    );
  }
}
