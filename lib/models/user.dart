class User {
  final String id;
  final String email;
  final String name;
  final bool isActive;
  final List<String> roles;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.isActive = true,
    this.roles = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] ?? '',
      isActive: json['isActive'] ?? true,
      roles: json['roles'] != null ? List<String>.from(json['roles']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'isActive': isActive,
      'roles': roles,
    };
  }
}
