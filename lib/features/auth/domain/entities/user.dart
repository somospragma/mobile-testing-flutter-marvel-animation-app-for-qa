class User {
  const User({
    required this.email,
    this.uid,
    this.displayName,
    this.password,
    this.token,
    this.gender,
  });

  final String email;
  final String? password;
  final String? token;
  final String? displayName;
  final String? uid;
  final String? gender;
}
