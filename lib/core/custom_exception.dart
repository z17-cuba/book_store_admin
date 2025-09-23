class CustomException {
  CustomException({
    required this.code,
    required this.errorMessage,
    this.data,
  });

  final int code;
  final String errorMessage;
  final Map<String, dynamic>? data;

  String? get dataErrors => data?.entries.map((entry) {
        final field = entry.key;
        final errors = entry.value;
        return '$field: ${errors.join(', ')}';
      }).join('\n');
}
