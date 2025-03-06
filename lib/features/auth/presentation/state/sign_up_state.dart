import '../../../../shared/domain/models/error_model.dart';

class SignUpState {

  SignUpState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.confirmPassword = '',
    this.gender = '',
    this.terms = false,
    this.alert,
  });
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String gender;
  final bool terms;
  final bool isLoading;
  final AlertModel? alert;

  SignUpState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    String? gender,
    bool? terms,
    bool? isLoading,
    AlertModel? alert,
  }) {
    return SignUpState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      gender: gender ?? this.gender,
      terms: terms ?? this.terms,
      isLoading: isLoading ?? this.isLoading,
      alert: alert ?? this.alert
    );
  }

  SignUpState reset() {
    return SignUpState();
  }
}
