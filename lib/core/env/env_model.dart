class EnvModel {
  EnvModel({
    required this.envDeploy,
    required String apiUrl,
  }) {
    _apiUrl = apiUrl;
  }
  String envDeploy;
  late String _apiUrl;

  String get apiUrl => _apiUrl;
}
