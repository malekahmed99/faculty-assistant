import 'package:ai_campus_guide/core/theme/app_colors.dart';
import 'package:ai_campus_guide/features/home_feature/presentation/widgets/feature_label.dart';
import 'package:ai_campus_guide/features/home_feature/presentation/widgets/search_section.dart';
import 'package:ai_campus_guide/features/service_feature/data/model/faq_item.dart';
import 'package:ai_campus_guide/features/service_feature/presentation/view/faq_card.dart';
import 'package:flutter/material.dart';

class FaqTab extends StatelessWidget {
  final List<FaqItem> faqs;
  final void Function(int) onToggle;
  const FaqTab({super.key, required this.faqs, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
            child: SearchSection(
              cursorColor: AppColors.primaryDark,
              fillColor: AppColors.surface,
              hintText: 'Search for some questions...',
              iconAndTextColor: AppColors.primary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    const BorderSide(color: AppColors.primaryDark, width: 1.5),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: FeatureLabel(label: 'Common Questions'),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => FaqCard(
              item: faqs[i],
              onTap: () => onToggle(i),
            ),
            childCount: faqs.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}
