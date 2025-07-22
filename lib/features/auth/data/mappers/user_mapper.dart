import '../../domain/entities/user.dart';
import '../models/user_model.dart';

class UserMapper {
  static User toEntity(UserModel model) {
    return User(
      email: model.email,
      uid: model.uid,
      displayName: model.displayName, // In UserModel, this comes from json['name']
      password: model.password,       // UserModel has password, User entity also has it
      token: model.token,             // UserModel has token, User entity also has it
      gender: model.gender,           // UserModel has gender, User entity also has it
    );
  }

  // Optional: if you need to convert from User entity back to UserModel (e.g., for sending data to an API)
  // static UserModel fromEntity(User entity) {
  //   return UserModel(
  //     email: entity.email,
  //     uid: entity.uid,
  //     displayName: entity.displayName,
  //     password: entity.password,
  //     token: entity.token,
  //     gender: entity.gender,
  //   );
  // }
}
