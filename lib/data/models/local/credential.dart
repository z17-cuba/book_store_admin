class Credential {
  Credential({
    required this.username,
    required this.password,
    this.email,
  });

  final String username;
  final String password;
  final String? email;
}
