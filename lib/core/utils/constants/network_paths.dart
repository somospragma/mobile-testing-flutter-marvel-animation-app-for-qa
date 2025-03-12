import '../../env/config_env.dart';
import '../../env/env_model.dart';

String getCharactersPath() {
  return 'characters';
}

String getCharacterComicsPath({required int character}) {
  EnvModel env = ConfigENV.intance.getAppEnv;
  return '${env.webComicsUrl}$character/3-d_man?utm_campaign=apiRef&utm_source=${env.apiKey}';
}

String getMapsPath() {
  return 'satellites/25544';
}