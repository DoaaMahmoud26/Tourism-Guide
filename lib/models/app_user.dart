
class AppUser {
  final String? uid;
  final String name;
  final String email;
  final DateTime? createdAt;

  AppUser({
    this.uid,
    required this.name,
    required this.email,
    this.createdAt,
  });

  // Convert User Object to Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'createdAt': createdAt,
    };
  }

  // Convert Map to User Object
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      createdAt: map['createdAt']?.toDate(),
    );
  }
}
