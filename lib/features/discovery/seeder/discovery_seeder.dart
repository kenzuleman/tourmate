import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controllers/auth_controller.dart';
import '../models/destination.dart';
import '../models/place.dart';

/// Seeds Firestore `destinations` + nested `places` from the bundled catalogue.
///
/// Source of truth: [assets/data/places_seed.json]. Regenerate from Python with:
/// `python scripts/build_places_seed.py`
class DiscoverySeeder {
  const DiscoverySeeder(this._db);

  final FirebaseFirestore _db;

  Future<bool> isSeeded() async {
    final snap = await _db.collection('destinations').limit(1).get();
    return snap.docs.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> _loadSeedDestinations() async {
    final raw = await rootBundle.loadString('assets/data/places_seed.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final version = decoded['schemaVersion'];
    if (version != 1) {
      throw FormatException(
        'Unsupported places_seed.json schemaVersion: $version (expected 1)',
      );
    }
    final list = decoded['destinations'] as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  }

  Future<void> seed() async {
    final seedData = await _loadSeedDestinations();
    final batch = _db.batch();

    for (final destData in seedData) {
      final destRef = _db.collection('destinations').doc();
      batch.set(
        destRef,
        Destination(
          id: destRef.id,
          name: destData['name'] as String,
          province: destData['province'] as String,
          type: destData['type'] as String,
          tags: List<String>.from(destData['tags'] as List? ?? []),
          imageUrl: destData['imageUrl'] as String? ?? '',
          description: destData['description'] as String? ?? '',
        ).toFirestore(),
      );

      final places = destData['places'] as List<dynamic>;
      for (final p in places) {
        final pData = p as Map<String, dynamic>;
        final placeRef = destRef.collection('places').doc();
        final coordRaw = pData['coordinates'];
        PlaceCoordinates? coords;
        if (coordRaw is Map<String, dynamic>) {
          coords = PlaceCoordinates.fromMap(coordRaw);
        }

        batch.set(
          placeRef,
          Place(
            id: placeRef.id,
            name: pData['name'] as String,
            category: pData['category'] as String? ?? 'attraction',
            tags: List<String>.from(pData['tags'] as List? ?? []),
            imageUrl: (pData['imageUrl'] as String?)?.trim() ?? '',
            description: pData['description'] as String? ?? '',
            funFact: pData['funFact'] as String? ?? '',
            contact: (pData['contact'] as String?)?.trim() ?? '',
            coordinates: coords,
          ).toFirestore(),
        );
      }
    }

    await batch.commit();
  }
}

final discoverySeederProvider = Provider<DiscoverySeeder>((ref) {
  return DiscoverySeeder(ref.watch(firestoreProvider));
});
