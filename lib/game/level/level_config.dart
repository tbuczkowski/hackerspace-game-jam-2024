import 'package:hackerspace_game_jam_2024/game/utils/file_utils.dart';

enum PlayerMovementType { walking, flying }

class SpeechDef {
  final int x;
  final int y;
  final String text;

  const SpeechDef(this.x, this.y, this.text);
}

class LevelConfig {
  final String filename;
  final PlayerMovementType playerMovementType;
  final List<SpeechDef> speeches;

  LevelConfig({
    required this.filename,
    this.playerMovementType = PlayerMovementType.walking,
    this.speeches = const [],
  });

  static Future<LevelConfig> load(String filename) async {
    Map<String, dynamic> raw = await FileUtils.loadJson(filename);

    List<dynamic>? rawSpeeches = raw['speeches'];
    List<SpeechDef>? speeches = rawSpeeches?.map((e) {
      Map<String, dynamic> s = e as Map<String, dynamic>;
      return SpeechDef(e['x'], e['y'], e['text']);
    }).toList();

    return LevelConfig(
        filename: raw['filename'],
        playerMovementType: PlayerMovementType.values.byName(raw['playerMovementType']),
        speeches: speeches ?? []);
  }
}
