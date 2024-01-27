import 'package:hackerspace_game_jam_2024/game/level/level_config.dart';
import 'package:hackerspace_game_jam_2024/game/utils/file_utils.dart';

class Levels {
  static const String ENTRY = 'level';
  static const String TOWER = 'tower_level';
}

Future<List<LevelConfig>> loadLevels() async {
  List<dynamic> levelConfigsList = await FileUtils.loadJson('assets/levels/_level_list.json');
  List<LevelConfig> levelList = await Future.wait(levelConfigsList.map((e) => LevelConfig.load('assets/levels/$e')));

  print('Loaded ${levelList.length} levels');

  return levelList;
}
