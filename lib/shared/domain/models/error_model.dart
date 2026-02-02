import 'dart:ui';

import 'package:flutter/material.dart';

class AlertModel {
  AlertModel({
    this.key,
    this.message,
    this.backgroundColor,
    this.currentAlert = false,
  });

  final Key? key;
  final String? message;
  final Color? backgroundColor;
  final bool currentAlert;

  AlertModel copyWith({
    Key? key,
    String? message,
    Color? backgroundColor,
    bool? currentAlert,
  }) {
    return AlertModel(
      key: key ?? this.key,
      message: message ?? this.message,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      currentAlert: currentAlert ?? this.currentAlert,
    );
  }
}
