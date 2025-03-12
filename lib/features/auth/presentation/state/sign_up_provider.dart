import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/entities/entity_either.dart';
import '../../../../core/network/error/failures.dart';
import '../../../../core/router/router.dart';
import '../../../../shared/domain/models/error_model.dart';
import '../../../../shared/presentation/tokens/tokens.dart';
import '../../domain/models/user_model.dart';
import '../../domain/usecases/auth_usecase.dart';
import 'sign_up_state.dart';

final AutoDisposeStateNotifierProvider<SignUpNotifier, SignUpState>
    signUpProvider =
    StateNotifierProvider.autoDispose<SignUpNotifier, SignUpState>(
        (Ref<SignUpState> ref) => SignUpNotifier(
              authUsecase: ref.read(authUsecaseProvider),
              router: ref.read(appRouterProvider),
            ));

class SignUpNotifier extends StateNotifier<SignUpState> {
  SignUpNotifier({
    required this.authUsecase,
    required this.router,
  }) : super(SignUpState());
  final AuthUsecase authUsecase;
  final GoRouter router;

  final List<DropdownMenuEntry<String>> genderEntries = [
    const DropdownMenuEntry(value: 'F', label: 'F'),
    const DropdownMenuEntry(value: 'M', label: 'M')
  ];

  void cleanAlert() {
    state = state.copyWith();
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateConfirmPassword(String password) {
    state = state.copyWith(confirmPassword: password);
  }

  void updateGender(String? gender) {
    state = state.copyWith(gender: gender);
  }

  void updateTerms(bool? terms) {
    state = state.copyWith(terms: terms);
  }

  Future<void> signUp() async {
    if ([state.email, state.password, state.name, state.gender]
            .any((field) => field.isEmpty) ||
        !state.terms) {
      state = state.copyWith(
        alert: AlertModel(
          message: 'All fields are required',
          backgroundColor: CustomColor.ERROR_COLOR,
        ),
      );
      return;
    }

    state = state.copyWith(isLoading: true);

    final Either<Failure, UserModel> response = await authUsecase.signUp(
        email: state.email, password: state.password, name: state.name);
    state = state.copyWith(isLoading: false);
    response.when((Failure left) {
      state = state.copyWith(
          alert: AlertModel(
              message: left.errorMessage,
              backgroundColor: CustomColor.ERROR_COLOR));
    }, (UserModel right) async {
      state = state.reset();
      state = state.copyWith(
          alert: AlertModel(
              message: 'Successful registration',
              backgroundColor: CustomColor.SUCCESS_COLOR));
    });
  }
}
