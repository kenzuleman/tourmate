import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controllers/auth_controller.dart';
import '../models/destination.dart';
import '../models/place.dart';

final destinationsStreamProvider = StreamProvider<List<Destination>>((ref) {
  final db = ref.watch(firestoreProvider);
  return db
      .collection('destinations')
      .snapshots()
      .map((snap) => snap.docs.map(Destination.fromFirestore).toList());
});

final destinationByIdProvider =
    FutureProvider.family<Destination?, String>((ref, id) async {
  final db = ref.watch(firestoreProvider);
  final doc = await db.collection('destinations').doc(id).get();
  if (!doc.exists) return null;
  return Destination.fromFirestore(doc);
});

final placesProvider =
    FutureProvider.family<List<Place>, ({String destId, String category})>(
        (ref, args) async {
  final db = ref.watch(firestoreProvider);
  Query<Map<String, dynamic>> query =
      db.collection('destinations').doc(args.destId).collection('places');
  if (args.category.isNotEmpty) {
    query = query.where('category', isEqualTo: args.category);
  }
  final snap = await query.get();
  return snap.docs.map(Place.fromFirestore).toList();
});

class SearchResult {
  const SearchResult({
    required this.destinations,
    required this.matchedProvince,
  });

  final List<Destination> destinations;
  final String? matchedProvince;
}

// Filter destinations by search query (case-insensitive province or name match)
SearchResult filterDestinations(
  List<Destination> all,
  String searchQuery,
) {
  if (searchQuery.isEmpty) {
    return SearchResult(destinations: all, matchedProvince: null);
  }

  final search = searchQuery.trim().toLowerCase();
  final provinces = all.map((d) => d.province).toSet();

  for (final province in provinces) {
    if (province.toLowerCase().contains(search)) {
      final inProvince = all.where((d) => d.province == province).toList();
      return SearchResult(
          destinations: inProvince, matchedProvince: province);
    }
  }

  final byName =
      all.where((d) => d.name.toLowerCase().contains(search)).toList();
  return SearchResult(destinations: byName, matchedProvince: null);
}
