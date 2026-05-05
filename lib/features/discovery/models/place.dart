import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceCoordinates {
  const PlaceCoordinates({required this.lat, required this.lng});

  final double lat;
  final double lng;

  factory PlaceCoordinates.fromMap(Map<String, dynamic> m) => PlaceCoordinates(
    lat: (m['lat'] as num?)?.toDouble() ?? 0.0,
    lng: (m['lng'] as num?)?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toMap() => {'lat': lat, 'lng': lng};
}

class Place {
  const Place({
    required this.id,
    required this.name,
    required this.category,
    required this.tags,
    required this.imageUrl,
    required this.description,
    required this.funFact,
    required this.contact,
    this.coordinates,
  });

  final String id;
  final String name;
  final String category;
  final List<String> tags;
  final String imageUrl;
  final String description;
  final String funFact;
  final String contact;
  final PlaceCoordinates? coordinates;

  factory Place.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    final coordMap = d['coordinates'] as Map<String, dynamic>?;
    return Place(
      id: doc.id,
      name: d['name'] as String? ?? '',
      category: d['category'] as String? ?? 'attraction',
      tags: List<String>.from(d['tags'] as List? ?? []),
      imageUrl: d['imageUrl'] as String? ?? '',
      description: d['description'] as String? ?? '',
      funFact: d['funFact'] as String? ?? '',
      contact: d['contact'] as String? ?? '',
      coordinates: coordMap != null ? PlaceCoordinates.fromMap(coordMap) : null,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'category': category,
    'tags': tags,
    'imageUrl': imageUrl,
    'description': description,
    'funFact': funFact,
    'contact': contact,
    if (coordinates != null) 'coordinates': coordinates!.toMap(),
  };
}
