import 'package:hackerspace_game_jam_2024/game/utils/file_utils.dart';

enum PlayerMovementType { walking, flying }

class SpeechDef {
  final int x;
  final int y;
  final String text;

  const SpeechDef(this.x, this.y, this.text);
}

class EnemyMovementDef {
  final int y;
  final int leftXBoundary;
  final int rightXBoundary;

  EnemyMovementDef(this.y, this.leftXBoundary, this.rightXBoundary);
}

class LevelConfig {
  final String filename;
  final PlayerMovementType playerMovementType;
  final List<SpeechDef> speeches;
  final List<EnemyMovementDef> enemyMovements;

  LevelConfig({
    required this.filename,
    this.playerMovementType = PlayerMovementType.walking,
    this.speeches = const [],
    this.enemyMovements = const [],
  });

  static Future<LevelConfig> load(String filename) async {
    Map<String, dynamic> raw = await FileUtils.loadJson(filename);

    return LevelConfig(
      filename: raw['filename'],
      playerMovementType: PlayerMovementType.values.byName(raw['playerMovementType']),
      speeches: _loadSpeeches(raw) ?? [],
      enemyMovements: _loadEnemyMovementDefs(raw) ?? [],
    );
  }

  static List<SpeechDef>? _loadSpeeches(Map<String, dynamic> raw) {
    List<dynamic>? rawSpeeches = raw['speeches'];
    List<SpeechDef>? speeches = rawSpeeches?.map((e) => SpeechDef(e['x'], e['y'], e['text'])).toList();
    return speeches;
  }

  static List<EnemyMovementDef>? _loadEnemyMovementDefs(Map<String, dynamic> raw) {
    List<dynamic>? rawMovements = raw['enemyMovementPaths'];
    List<EnemyMovementDef>? movements =
        rawMovements?.map((e) => EnemyMovementDef(e['y'], e['leftXBoundary'], e['rightXBoundary'])).toList();

    return movements;
  }
}
