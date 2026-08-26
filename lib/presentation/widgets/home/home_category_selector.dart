import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:propertyhub/presentation/providers/property_provider.dart';
import 'package:propertyhub/presentation/widgets/common/category_chip.dart';

class HomeCategorySelector extends ConsumerWidget {
  const HomeCategorySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(homeCategoryProvider);
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => ref.read(homeCategoryProvider.notifier).state = 'For Sale',
            child: CategoryChip(label: 'For Sale', isSelected: selectedCategory == 'For Sale'),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => ref.read(homeCategoryProvider.notifier).state = 'For Rent',
            child: CategoryChip(label: 'For Rent', isSelected: selectedCategory == 'For Rent'),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => ref.read(homeCategoryProvider.notifier).state = 'Commercial',
            child: CategoryChip(label: 'Commercial', isSelected: selectedCategory == 'Commercial'),
          ),
        ],
      ),
    );
  }
}
