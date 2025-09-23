import 'package:book_store_admin/data/models/parse_types/parse_pointer.dart';

class UserCheckoutsModel {
  UserCheckoutsModel({
    required this.dueDate,
    required this.book,
    required this.user,
    this.createdAt,
    this.updatedAt,
    required this.status,
    required this.checkoutDate,
  });

  final DateTime? dueDate;
  final ParsePointer? book;
  final ParsePointer? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? status;
  final DateTime? checkoutDate;

  factory UserCheckoutsModel.fromJson(Map<String, dynamic> json) {
    return UserCheckoutsModel(
      dueDate: DateTime.tryParse(json["dueDate"]['iso'] ?? ""),
      book: json["book"] == null ? null : ParsePointer.fromJson(json["book"]),
      user: json["user"] == null ? null : ParsePointer.fromJson(json["user"]),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      status: json["status"],
      checkoutDate: DateTime.tryParse(json["checkoutDate"]['iso'] ?? ""),
    );
  }

  @override
  String toString() {
    return "$dueDate, $book, $user, $status, $createdAt, $updatedAt, $checkoutDate, ";
  }
}
