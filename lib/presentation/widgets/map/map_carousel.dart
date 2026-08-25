import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';
import 'package:propertyhub/data/models/property_model.dart';
import 'package:propertyhub/presentation/widgets/map/map_carousel_card.dart';
import 'dart:ui';

class MapCarousel extends StatefulWidget {
  final List<PropertyModel> properties;
  final PropertyModel? selectedProperty;
  final String searchQuery;

  const MapCarousel({
    super.key,
    required this.properties,
    this.selectedProperty,
    required this.searchQuery,
  });

  @override
  State<MapCarousel> createState() => _MapCarouselState();
}

class _MapCarouselState extends State<MapCarousel> {
  bool _isExpanded = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant MapCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedProperty != null && widget.selectedProperty != oldWidget.selectedProperty) {
      setState(() {
        _isExpanded = true;
      });
      final index = widget.properties.indexWhere((p) => p.id == widget.selectedProperty!.id);
      if (index != -1 && _scrollController.hasClients) {
        _scrollController.animateTo(
          index * 304.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.properties.isEmpty || (widget.searchQuery.isEmpty && widget.selectedProperty == null)) {
      return const SizedBox.shrink();
    }

    String title = 'Explore Properties';
    if (widget.searchQuery.isNotEmpty) {
      title = 'Search Results';
    }
    
    final count = widget.properties.length;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 24, bottom: _isExpanded ? 32 : 24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTypography.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$count Properties Available',
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      ),
                      icon: Icon(
                        _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: SizedBox(
                  height: _isExpanded ? 266 : 0, 
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.properties.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final property = widget.properties[index];
                            
                            return Container(
                              padding: const EdgeInsets.all(4),
                              child: MapCarouselCard(
                                property: property,
                                onTap: () {
                                  context.push('/property/${property.id}');
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
