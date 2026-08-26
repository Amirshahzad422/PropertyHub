import 'package:flutter/material.dart';

class PropertyImageGallery extends StatelessWidget {
  final List<String> photos;

  const PropertyImageGallery({
    super.key,
    required this.photos,
  });

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image, size: 64, color: Colors.grey),
      );
    }

    return PageView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Image.network(
          photos[index],
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
          ),
        );
      },
    );
  }
}
