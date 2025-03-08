class EnvModel {
  EnvModel({
    required this.envDeploy,
    required this.apiKey,
    required this.hash,
    required this.ts,
    required this.webComicsUrl,
    required String apiUrl,
  }) {
    _apiUrl = apiUrl;
  }
  String apiKey;
  String hash;
  String ts;
  String envDeploy;
  String webComicsUrl;
  late String _apiUrl;
  

  String get apiUrl => _apiUrl;
}
