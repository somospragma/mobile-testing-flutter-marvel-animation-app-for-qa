
class UserModel {
  const UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'].toString(),
      password: json['password']?.toString(),
      token: json['token']?.toString(),
      displayName: json['name']?.toString(), 
      uid: json['uid']?.toString(),
      gender: json['gender']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'name': displayName, 
      'uid': uid,
      'gender': gender,
    };
  }

  UserModel copyWith({
    String? email,
    String? password,
    String? token,
    String? displayName,
    String? uid,
    String? gender,
  }) {
    return UserModel(
      email: email ?? this.email,
      password: password ?? this.password,
      token: token ?? this.token,
      displayName: displayName ?? this.displayName,
      uid: uid ?? this.uid,
      gender: gender ?? this.gender,
    );
  }
}
