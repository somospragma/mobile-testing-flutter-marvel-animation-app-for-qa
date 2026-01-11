import 'package:flutter/material.dart';

/// Widget keys constants for the Marvel Animation App
///
/// This file centralizes all widget keys used throughout the app
/// to avoid string duplication and improve maintainability,
/// especially for testing purposes.
class WidgetKeys {
  WidgetKeys._();

  // login Keys
  static const ValueKey emailInput = ValueKey('email_input');
  static const ValueKey passwordInput = ValueKey('password_input');
  static const ValueKey loginButton = ValueKey('login_button');
  static const ValueKey signUpButton = ValueKey('sign-up_btn');
  static const ValueKey forgotPasswordButton = ValueKey('forgot-password_btn');
  static const ValueKey loginErrorSnackBar = ValueKey('login_error_snackbar');

  // signup Keys
  static const ValueKey signUpNameInput = ValueKey('sign_up_name_input');
  static const ValueKey signUpEmailInput = ValueKey('sign_up_email_input');
  static const ValueKey signUpPasswordInput =
      ValueKey('sign_up_password_input');
  static const ValueKey signUpConfirmPasswordInput =
      ValueKey('sign_up_confirm_password_input');
  static const ValueKey signUpGenderDropdown =
      ValueKey('sign_up_gender_dropdown');
  static const ValueKey signUpTermsCheckbox =
      ValueKey('sign_up_terms_checkbox');
  static const ValueKey backToLoginButton = ValueKey('back_to_login_button');

  // reset password Keys
  static const ValueKey resetPasswordEmailInput =
      ValueKey('reset_password_email_input');
  static const ValueKey resetPasswordSubmitButton =
      ValueKey('reset_password_submit_button');

  // Home Page Keys
  static const ValueKey homePage = ValueKey('home_page');
}
