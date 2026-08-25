import 'package:flutter/material.dart';
import 'package:propertyhub/core/themes/app_colors.dart';

class SkeletonContainer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonContainer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  State<SkeletonContainer> createState() => _SkeletonContainerState();
}

class _SkeletonContainerState extends State<SkeletonContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }
}

class PropertyCardSkeleton extends StatelessWidget {
  final EdgeInsetsGeometry? margin;

  const PropertyCardSkeleton({super.key, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          const SkeletonContainer(
            width: double.infinity,
            height: 220,
            borderRadius: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price
                const SkeletonContainer(width: 140, height: 28),
                const SizedBox(height: 8),
                // Title & Location
                const SkeletonContainer(width: 200, height: 16),
                const SizedBox(height: 16),
                // Amenities Wrap
                Wrap(
                  spacing: 16,
                  runSpacing: 4,
                  children: const [
                    SkeletonContainer(width: 50, height: 16),
                    SkeletonContainer(width: 50, height: 16),
                    SkeletonContainer(width: 70, height: 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GridPropertyCardSkeleton extends StatelessWidget {
  const GridPropertyCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          const Expanded(
            flex: 5,
            child: SkeletonContainer(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 16,
            ),
          ),
          // Details Section
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  SkeletonContainer(width: 80, height: 20),
                  SkeletonContainer(width: 120, height: 16),
                  SkeletonContainer(width: 100, height: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
