// ignore_for_file: avoid_dynamic_calls

class ApiResponseModel<T> {
  ApiResponseModel({
    required this.status,
    required this.results,
  });

  late final String? status;
  late final T? results;

  static ApiResponseModel<T> fromJson<T>(Map<dynamic, dynamic> json, Function tFromJson) {
    return ApiResponseModel<T>(
      status: json['status'].toString(),
      results: tFromJson(json['results']) as T,
    );
  }

}
