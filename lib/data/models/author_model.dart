class AuthorModel {
  AuthorModel({
    this.objectId,
    this.createdAt,
    this.updatedAt,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.nationality,
    this.photoUrl,
    this.birthDate,
    required this.websiteUrl,
  });

  final String? objectId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? firstName;
  final String? lastName;
  final String? bio;
  final String? nationality;
  final String? photoUrl;
  final DateTime? birthDate;
  final String? websiteUrl;

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      objectId: json["objectId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      firstName: json["firstName"],
      lastName: json["lastName"],
      bio: json["bio"],
      nationality: json["nationality"],
      photoUrl: json["photo"] != null ? json["photo"]['url'] : null,
      birthDate: json["birthDate"] != null && json["birthDate"]['iso'] != null
          ? DateTime.tryParse(json["birthDate"]['iso'] ?? "")
          : null,
      websiteUrl: json["websiteUrl"],
    );
  }

  @override
  String toString() {
    return "$objectId, $createdAt, $updatedAt, $bio, $nationality, $photoUrl, $firstName, $lastName, $birthDate, $websiteUrl, ";
  }
}
