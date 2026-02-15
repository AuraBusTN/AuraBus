class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? picture;
  final int points;
  final int? rank;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.picture,
    this.points = 0,
    this.rank,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory User.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null || (json['id'] as String).isEmpty) {
      throw const FormatException('Missing required field: id');
    }
    final emailVal = json['email'] as String? ?? '';

    return User(
      id: json['id'] as String,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: emailVal,
      picture: json['picture'] as String?,
      points: json['points'] is int ? json['points'] : 0,
      rank: json['rank'] as int?,
    );
  }
}
