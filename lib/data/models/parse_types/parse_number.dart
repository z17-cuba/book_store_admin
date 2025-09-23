class ParseNumber {
  ParseNumber({
    required this.className,
    required this.estimateNumber,
    required this.savedNumber,
    required this.setMode,
    required this.lastPreformedOperation,
  });

  final String? className;
  final double? estimateNumber;
  final double? savedNumber;
  final bool? setMode;
  final dynamic lastPreformedOperation;

  double get value => savedNumber ?? 0;

  factory ParseNumber.fromJson(Map<String, dynamic> json) {
    return ParseNumber(
      className: json["className"],
      estimateNumber: json["estimateNumber"],
      savedNumber: json["savedNumber"],
      setMode: json["setMode"],
      lastPreformedOperation: json["lastPreformedOperation"],
    );
  }

  @override
  String toString() {
    return "$className, $estimateNumber, $savedNumber, $setMode, $lastPreformedOperation, ";
  }
}
