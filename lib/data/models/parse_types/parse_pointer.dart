class ParsePointer {
  ParsePointer({
    required this.className,
    required this.objectId,
  });

  final String? className;
  final String? objectId;

  factory ParsePointer.fromJson(Map<String, dynamic> json) {
    return ParsePointer(
      className: json["className"],
      objectId: json["objectId"],
    );
  }

  @override
  String toString() {
    return "$className, $objectId, ";
  }
}
