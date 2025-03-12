import '../../../../shared/domain/models/error_model.dart';

class LogInState {

  LogInState({
    this.email = '',
    this.password = '',
    this.name = '',
    this.isLoading = false,
    this.alert,
  });
  final String email;
  final String password;
  final String name;
  final bool isLoading;
  final AlertModel? alert;

  LogInState copyWith({
    String? email,
    String? password,
    String? name,
    bool? isLoading,
    AlertModel? alert,
  }) {
    return LogInState(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      isLoading: isLoading ?? this.isLoading,
      alert: alert ?? this.alert,
    );
  }
}
