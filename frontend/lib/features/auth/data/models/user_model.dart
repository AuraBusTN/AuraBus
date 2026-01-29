class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null || (json['id'] as String).isEmpty) {
      throw const FormatException('Missing required field: id');
    }
    if (json['email'] == null || (json['email'] as String).isEmpty) {
      throw const FormatException('Missing required field: email');
    }

    return User(
      id: json['id'] as String,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] as String,
    );
  }
}
