import 'package:dio/dio.dart';

import '../env/config_env.dart';

class DioNetwork {
  static late Dio appAPI;

  static void initDio() {
    appAPI = Dio(BaseOptions(
        baseUrl: ConfigENV.intance.appEnv.apiUrl,
        contentType: Headers.jsonContentType));
  }
}
