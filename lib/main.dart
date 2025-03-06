import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app.dart';
import 'core/env/config_env.dart';
import 'core/network/dio_network.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ConfigENV.intance.loadEnvironment();
  await ScreenUtil.ensureScreenSize();
  DioNetwork.initDio();
  runApp(const ProviderScope(child: MainApp()));
}
