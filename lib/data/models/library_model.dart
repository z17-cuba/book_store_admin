import 'package:book_store_admin/data/models/parse_types/parse_pointer.dart';

class LibraryModel {
  LibraryModel({
    this.className,
    this.objectId,
    this.createdAt,
    this.updatedAt,
    this.userId,
    //Address
    required this.city,
    required this.address,
    required this.state,
    required this.country,
    required this.zipCode,
    //Address -- Contact
    required this.name,
    required this.phone,
    required this.email,
    required this.websiteUrl,
    // Contact
    this.status,
  });

  final String? className;
  final String? objectId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  //Address
  final String? city;
  final String? address;
  final String? state;
  final String? country;
  final String? zipCode;
  //Address -- Contact
  final String? name;
  final String? phone;
  final String? email;
  final String? websiteUrl;
  // Contact
  final String? status;
  final ParsePointer? userId;

  factory LibraryModel.fromJson(Map<String, dynamic> json) {
    return LibraryModel(
      className: json["className"],
      objectId: json["objectId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      //Address
      city: json['city'],
      address: json["address"],
      state: json["state"],
      country: json["country"],
      zipCode: json["zipCode"],
      //Address -- Contact
      name: json['name'],
      phone: json["phone"],
      email: json["email"],
      websiteUrl: json["websiteUrl"],
      // Contact
      status: json["status"],
      userId:
          json["userId"] == null ? null : ParsePointer.fromJson(json["userId"]),
    );
  }

  @override
  String toString() {
    return "$className, $objectId, $createdAt, $updatedAt, $city, $address, $state, $country, $name, $phone, $email, $websiteUrl,$status, $zipCode, $userId";
  }
}
