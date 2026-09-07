class UserModel {
  final int id;
  final String email;
  final String name;
  final String avatar;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      avatar: (json['avatar'] as String?) ?? '',
    );
  }
}
