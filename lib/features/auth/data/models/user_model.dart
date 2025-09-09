class UserModel {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  final DateTime? birthDate;
  final double? weight;
  final double? height;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    this.birthDate,
    this.weight,
    this.height,
    this.avatarUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'birthDate': birthDate?.toUtc().toIso8601String(),
      'weight': weight,
      'height': height,
      'avatarUrl': avatarUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '')?.toLocal() ??
          DateTime.now(),
      birthDate:
          DateTime.tryParse(map['birthDate'] as String? ?? '')?.toLocal(),
      weight: (map['weight'] is num) ? (map['weight'] as num).toDouble() : null,
      height: (map['height'] is num) ? (map['height'] as num).toDouble() : null,
      avatarUrl: map['avatarUrl'] as String?,
    );
  }

  factory UserModel.basic({
    required String id,
    required String name,
    required String email,
    DateTime? birthDate,
    double? weight,
    double? height,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id,
      name: name,
      email: email,
      createdAt: DateTime.now(),
      birthDate: birthDate,
      weight: weight,
      height: height,
      avatarUrl: avatarUrl,
    );
  }
}
