import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../../../../core/router/router.dart';
import '../../../../shared/constants/widget_keys.dart';
import '../../../../shared/domain/models/error_model.dart';
import '../../../../shared/presentation/tokens/tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/auth_usecase.dart';
import 'log_in_state.dart';

final NotifierProvider<LogInNotifier, LogInState> logInProvider =
    NotifierProvider<LogInNotifier, LogInState>(() => LogInNotifier());

class LogInNotifier extends Notifier<LogInState> {
  late final AuthUsecase authUsecase;
  late final GoRouter router;

  @override
  LogInState build() {
    authUsecase = ref.read(authUsecaseProvider);
    router = ref.read(appRouterProvider);
    return LogInState();
  }

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
          key: WidgetKeys.loginErrorSnackBar,
          message: 'All fields are required',
          backgroundColor: CustomColor.ERROR_COLOR,
        ),
      );
      return;
    }

    state = state.copyWith(isLoading: true);

    final Either<Failure, User> response =
        await authUsecase.logIn(email: state.email, password: state.password);
    state = state.copyWith(isLoading: false);
    response.when((Failure left) {
      state = state.copyWith(
        alert: AlertModel(
          key: WidgetKeys.loginErrorSnackBar,
          message: left.errorMessage,
          backgroundColor: CustomColor.ERROR_COLOR,
        ),
      );
    }, (User right) async {
      state = state.copyWith(name: right.displayName);
      router.push('/main');
    });
  }
}
