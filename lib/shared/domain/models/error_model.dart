import 'dart:ui';

class AlertModel {
  AlertModel({this.message, this.backgroundColor, this.currentAlert = false});
  final String? message;
  final Color? backgroundColor;
  final bool currentAlert;

  AlertModel copyWith({
    String? message,
    Color? backgroundColor,
    bool? currentAlert,
  }) {
    return AlertModel(
      message: message ?? this.message,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      currentAlert: currentAlert ?? this.currentAlert,
    );
  }
}
