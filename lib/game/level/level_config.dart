
import 'package:hackerspace_game_jam_2024/game/utils/file_utils.dart';

enum PlayerMovementType { walking, flying }

class LevelConfig {
  final String filename;
  final PlayerMovementType playerMovementType;

  LevelConfig({
    required this.filename,
    this.playerMovementType = PlayerMovementType.walking,
  });

  static Future<LevelConfig> load(String filename) async {
    Map<String, dynamic> raw = await FileUtils.loadJson(filename);

    return LevelConfig(
      filename: raw['filename'],
      playerMovementType:
          PlayerMovementType.values.byName(raw['playerMovementType']),
    );
  }
}
