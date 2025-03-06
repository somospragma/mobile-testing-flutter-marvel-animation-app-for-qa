import '../../../../shared/domain/models/error_model.dart';

class LogInState {

  LogInState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.alert,
  });
  final String email;
  final String password;
  final bool isLoading;
  final AlertModel? alert;

  LogInState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    AlertModel? alert,
  }) {
    return LogInState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      alert: alert ?? this.alert,
    );
  }
}
