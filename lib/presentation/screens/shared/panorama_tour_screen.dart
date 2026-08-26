import 'package:flutter/material.dart';
import 'package:propertyhub/data/models/property_model.dart';
import 'package:propertyhub/presentation/widgets/property/panorama_viewer.dart';

class PanoramaTourScreen extends StatelessWidget {
  final PropertyModel property;

  const PanoramaTourScreen({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    final panoramaUrl = property.panorama360Url;

    if (panoramaUrl == null || panoramaUrl.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.panorama_photosphere, size: 64, color: Colors.white54),
              const SizedBox(height: 16),
              const Text(
                'No 360° Tour Available',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                'This property does not have a virtual tour.',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return PanoramaViewer(
      imageUrl: panoramaUrl,
    );
  }
}
