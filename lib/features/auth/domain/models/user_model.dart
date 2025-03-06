class UserModel {
  const UserModel({
    required this.email,
    this.uid,
    this.displayName,
    this.password,
    this.token,
  });
  final String email;
  final String? password;
  final String? token;
  final String? displayName;
  final String? uid;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': email,
      'password': password,
      'firstName': displayName,
      'uid': uid,
    };
  }

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'].toString(),
      password: json['password'].toString(),
      token: json['token'].toString(),
      displayName: json['name'].toString(),
      uid: json['uid'].toString(),
    );
  }

  UserModel copyWith({
    String? email,
    String? password,
    String? token,
    String? name,
    String? uid,
  }) {
    return UserModel(
      email: email ?? this.email,
      password: password ?? this.password,
      token: token ?? this.token,
      displayName: name ?? this.displayName,
      uid: uid ?? this.uid,
    );
  }
}
