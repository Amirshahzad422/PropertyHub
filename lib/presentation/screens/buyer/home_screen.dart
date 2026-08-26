import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:propertyhub/presentation/widgets/home/home_hero_banner.dart';
import 'package:propertyhub/presentation/widgets/home/home_category_selector.dart';
import 'package:propertyhub/presentation/widgets/home/home_recommended_properties.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          HomeHeroBanner(),
          SizedBox(height: 24),
          HomeCategorySelector(),
          SizedBox(height: 32),
          HomeRecommendedProperties(),
          SizedBox(height: 48), 
        ],
      ),
    );
  }
}
