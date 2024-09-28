class MyUserEntity {
  String userId;
  String email;
  String name;
  String roles;

  MyUserEntity({
    required this.userId,
    required this.email,
    required this.name,
    required this.roles,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'roles': roles,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
        userId: doc['userId'],
        email: doc['email'],
        name: doc['name'],
        roles: doc['roles']);
  }
}
