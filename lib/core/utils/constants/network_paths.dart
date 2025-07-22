import '../../env/config_env.dart';
import '../../env/env_model.dart';

String getHeroPath(int heroId) {
  EnvModel env = ConfigENV.intance.getAppEnv;
  return '${env.apiToken}/$heroId';
}

String getCharacterComicsPath({required int character}) {
  EnvModel env = ConfigENV.intance.getAppEnv;
  return '${env.webComicsUrl}$character';
}

String getMapsPath() {
  return 'satellites/25544';
}