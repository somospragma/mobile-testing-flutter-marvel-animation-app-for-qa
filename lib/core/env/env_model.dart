class EnvModel {
  EnvModel({
    required this.envDeploy,
    required this.apiKey,
    required this.hash,
    required this.ts,
    required String apiUrl,
  }) {
    _apiUrl = apiUrl;
  }
  String apiKey;
  String hash;
  String ts;
  String envDeploy;
  late String _apiUrl;
  

  String get apiUrl => _apiUrl;
}
