import 'package:cloud_firestore/cloud_firestore.dart';

class Destination {
  const Destination({
    required this.id,
    required this.name,
    required this.province,
    required this.type,
    required this.tags,
    required this.imageUrl,
    required this.description,
  });

  final String id;
  final String name;
  final String province;
  final String type;
  final List<String> tags;
  final String imageUrl;
  final String description;

  factory Destination.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Destination(
      id: doc.id,
      name: d['name'] as String? ?? '',
      province: d['province'] as String? ?? '',
      type: d['type'] as String? ?? 'city',
      tags: List<String>.from(d['tags'] as List? ?? []),
      imageUrl: d['imageUrl'] as String? ?? '',
      description: d['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'province': province,
    'type': type,
    'tags': tags,
    'imageUrl': imageUrl,
    'description': description,
  };
}
