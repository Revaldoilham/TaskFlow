// lib/data/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? role;
  final String? phone;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.role,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    avatar: json['avatar'],
    role: json['role'],
    phone: json['phone'],
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'email': email,
    'avatar': avatar, 'role': role, 'phone': phone,
  };

  UserModel copyWith({String? name, String? email, String? avatar, String? role, String? phone}) =>
    UserModel(
      id: id, name: name ?? this.name, email: email ?? this.email,
      avatar: avatar ?? this.avatar, role: role ?? this.role, phone: phone ?? this.phone,
    );

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}