class EnvModel {
  EnvModel({
    required this.envDeploy,
    required this.apiToken,
    required this.webComicsUrl,
    required this.mapsApiUrl,
    required String apiUrl,
  }) {
    _apiUrl = apiUrl;
  }
  String apiToken;
  String envDeploy;
  String webComicsUrl;
  String mapsApiUrl;
  late String _apiUrl;
  

  String get apiUrl => _apiUrl;
}
