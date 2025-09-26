class PublisherModel {
  PublisherModel({
    this.className,
    this.objectId,
    this.createdAt,
    this.updatedAt,
    required this.address,
    required this.name,
    required this.phone,
    required this.email,
    required this.websiteUrl,
  });

  final String? className;
  final String? objectId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? address;
  final String? name;
  final String? phone;
  final String? email;
  final String? websiteUrl;

  factory PublisherModel.fromJson(Map<String, dynamic> json) {
    return PublisherModel(
      className: json["className"],
      objectId: json["objectId"],
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"] ?? "")
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.tryParse(json["updatedAt"] ?? "")
          : null,
      address: json["address"],
      name: json['name'],
      email: json["contactEmail"],
      phone: json["phone"],
      websiteUrl: json["websiteUrl"],
    );
  }

  @override
  String toString() {
    return "$className, $objectId, $createdAt, $updatedAt, $address, $name, $phone, $email, $websiteUrl ";
  }
}
