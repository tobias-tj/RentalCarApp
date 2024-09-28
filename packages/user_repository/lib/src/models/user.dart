import 'package:user_repository/src/entities/entities.dart';

class MyUser {
  String userId;
  String email;
  String name;
  String roles;

  MyUser({
    required this.userId,
    required this.email,
    required this.name,
    required this.roles,
  });

  static final empty = MyUser(userId: '', email: '', name: '', roles: '');

  MyUserEntity toEntity() {
    return MyUserEntity(userId: userId, email: email, name: name, roles: roles);
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
        userId: entity.userId,
        email: entity.email,
        name: entity.name,
        roles: entity.roles);
  }

  @override
  String toString() {
    return 'MyUser: $userId, $email, $name, $roles';
  }
}
