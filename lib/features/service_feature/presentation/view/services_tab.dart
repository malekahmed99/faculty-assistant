import 'package:ai_campus_guide/features/home_feature/presentation/widgets/feature_label.dart';
import 'package:ai_campus_guide/features/service_feature/data/static/static_data.dart';
import 'package:ai_campus_guide/features/service_feature/presentation/widgets/service_card.dart';
import 'package:flutter/material.dart';

class ServicesTab extends StatelessWidget {
  const ServicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final services = buildServices(context); // ← يبني القايمة مع الـ context

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
        const SliverToBoxAdapter(
          child: FeatureLabel(label: 'Academical Services'),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) => ServiceCard(item: services[i]),
              childCount: services.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}
