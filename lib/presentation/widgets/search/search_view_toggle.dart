import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:propertyhub/core/themes/app_colors.dart';

final viewModeProvider = StateProvider.autoDispose<int>((ref) => 0);

class SearchViewToggle extends ConsumerWidget {
  const SearchViewToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(viewModeProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildToggleBtn(0, Icons.view_list_rounded, viewMode, ref)),
          Expanded(child: _buildToggleBtn(1, Icons.grid_view_rounded, viewMode, ref)),
          Expanded(child: _buildToggleBtn(2, Icons.map_rounded, viewMode, ref)),
        ],
      ),
    );
  }

  Widget _buildToggleBtn(int index, IconData icon, int viewMode, WidgetRef ref) {
    final isSelected = viewMode == index;
    return GestureDetector(
      onTap: () {
        ref.read(viewModeProvider.notifier).state = index;
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceVariant : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
