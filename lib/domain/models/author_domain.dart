class AuthorDomain {
  AuthorDomain({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.description,
    this.photoUrl,
    required this.nationality,
    required this.websiteUrl,
    this.birthDate,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? description;
  final String? photoUrl;
  final String? nationality;
  final String? websiteUrl;
  final DateTime? birthDate;

  String get fullName => '$firstName $lastName';
}
