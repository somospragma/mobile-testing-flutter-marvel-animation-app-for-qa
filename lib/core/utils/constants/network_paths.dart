import '../../env/config_env.dart';
import '../../env/env_model.dart';

String getHeroPath(int heroId) {
  EnvModel env = ConfigENV.intance.getAppEnv;
  // La API_URL ya incluye el slash final: "https://superheroapi.com/api/"
  return '${env.apiUrl}${env.apiToken}/$heroId';
}

String getHeroImagePath(int heroId) {
  EnvModel env = ConfigENV.intance.getAppEnv;
  // La API_URL ya incluye el slash final: "https://superheroapi.com/api/"
  return '${env.apiUrl}${env.apiToken}/$heroId/image';
}

String getSearchPath(String name) {
  EnvModel env = ConfigENV.intance.getAppEnv;
  // La API_URL ya incluye el slash final: "https://superheroapi.com/api/"
  return '${env.apiUrl}${env.apiToken}/search/$name';
}

String getCharacterComicsPath({required int character}) {
  EnvModel env = ConfigENV.intance.getAppEnv;
  return '${env.webComicsUrl}$character';
}

String getMapsPath() {
  return 'satellites/25544';
}
