import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:propertyhub/presentation/widgets/common/loader_skeleton.dart';
import 'package:propertyhub/presentation/widgets/search/search_view_toggle.dart';

class SearchLoadingState extends ConsumerWidget {
  const SearchLoadingState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(viewModeProvider);

    if (viewMode == 0) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: 3,
        itemBuilder: (context, index) => const PropertyCardSkeleton(),
      );
    } else if (viewMode == 1) {
      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => const GridPropertyCardSkeleton(),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
