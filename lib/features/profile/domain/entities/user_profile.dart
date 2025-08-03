class UserProfile {
  final String id;
  final String name;
  final String? email;
  final String? bio;
  final String? profileImageUrl;
  final DateTime? createdAt;

  UserProfile({
    required this.id,
    required this.name,
    this.email,
    this.bio,
    this.profileImageUrl,
    this.createdAt,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map, String id) {
    return UserProfile(
      id: id,
      name: map['name'] ?? '',
      email: map['email'],
      bio: map['bio'],
      profileImageUrl: map['profileImageUrl'],
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as dynamic).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt,
    };
  }
} 