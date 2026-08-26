import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:propertyhub/data/models/property_model.dart';
import 'package:propertyhub/presentation/providers/property_provider.dart';

import 'package:propertyhub/presentation/providers/auth_provider.dart';
import 'package:propertyhub/data/repositories/settings_repository.dart';
import 'package:propertyhub/data/repositories_impl/settings_repository_impl.dart';

final mapCameraPositionProvider = StateProvider<CameraPosition>((ref) {
  return const CameraPosition(
    target: LatLng(31.5204, 74.3587),
    zoom: 10.0,
  );
});

final selectedMapPropertyProvider = StateProvider<PropertyModel?>((ref) {
  return null;
});

final mapMarkersProvider = Provider<List<PropertyModel>>((ref) {
  final properties = ref.watch(searchPropertiesProvider).valueOrNull ?? [];
  return properties;
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(firestore: ref.watch(firebaseFirestoreProvider));
});


