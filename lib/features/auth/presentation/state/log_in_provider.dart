import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../../../../core/router/router.dart';
import '../../../../shared/domain/models/error_model.dart';
import '../../../../shared/presentation/tokens/tokens.dart';
import '../../domain/models/user_model.dart';
import '../../domain/usecases/auth_usecase.dart';
import 'log_in_state.dart';

final StateNotifierProvider<LogInNotifier, LogInState> logInProvider =
    StateNotifierProvider<LogInNotifier, LogInState>((Ref<LogInState> ref) => LogInNotifier(
          authUsecase: ref.read(authUsecaseProvider),
          router: ref.read(appRouterProvider),
        ));

class LogInNotifier extends StateNotifier<LogInState> {

  LogInNotifier({
    required this.authUsecase,
    required this.router,
  }) : super(LogInState());
  final AuthUsecase authUsecase;
  final GoRouter router;

  void cleanAlert() {
    state = state.copyWith();
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  Future<void> logIn() async {
    if (state.email.isEmpty || state.password.isEmpty) {
      state = state.copyWith(
          alert: AlertModel(
              message: 'All fields are required',
              backgroundColor: CustomColor.ERROR_COLOR));
      return;
    }

    state = state.copyWith(isLoading: true);

    final Either<Failure, UserModel> response =
        await authUsecase.logIn(email: state.email, password: state.password);
    state = state.copyWith(isLoading: false);
    response.when((Failure left) {
      state = state.copyWith(
          alert: AlertModel(
              message: left.errorMessage,
              backgroundColor: CustomColor.ERROR_COLOR));
    }, (UserModel right) async {
      router.push('/main');
    });
  }
}
