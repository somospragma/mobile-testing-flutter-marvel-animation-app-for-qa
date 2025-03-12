import 'package:dio/dio.dart';

import '../env/config_env.dart';

class DioNetwork {
  static Dio getDio({String? baseUrl}) {
    return Dio(BaseOptions(
      baseUrl: baseUrl ?? ConfigENV.intance.appEnv.apiUrl,
      contentType: Headers.jsonContentType,
    ));
  }
}
