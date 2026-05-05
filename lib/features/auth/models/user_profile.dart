class UserProfile {
  const UserProfile({
    required this.uid,
    required this.username,
    required this.fullName,
    required this.age,
    required this.email,
    required this.preferences,
    this.createdAt,
  });

  final String uid;
  final String username;
  final String fullName;
  final int age;
  final String email;
  final String preferences;
  final DateTime? createdAt;

  Map<String, dynamic> toFirestore() => {
        'uid': uid,
        'username': username,
        'fullName': fullName,
        'age': age,
        'email': email,
        'preferences': preferences,
        'createdAt': createdAt?.toIso8601String() ??
            DateTime.now().toIso8601String(),
      };

  factory UserProfile.fromFirestore(Map<String, dynamic> data) {
    return UserProfile(
      uid: data['uid'] as String? ?? '',
      username: data['username'] as String? ?? '',
      fullName: data['fullName'] as String? ?? '',
      age: (data['age'] as num?)?.toInt() ?? 0,
      email: data['email'] as String? ?? '',
      preferences: data['preferences'] as String? ?? '',
      createdAt: DateTime.tryParse(data['createdAt'] as String? ?? ''),
    );
  }
}
