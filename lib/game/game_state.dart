import 'package:hackerspace_game_jam_2024/game/level/level_config.dart';
import 'package:hackerspace_game_jam_2024/game/level/levels.dart';

class GameState {
  static GameState? _instance;

  static Future<GameState> getInstance() async {
    if (_instance == null) {
      _instance = GameState._();
      await _instance!.initialize();
    }

    return _instance!;
  }

  static void reset() => _instance = null;

  GameState._();

  int currentLevel = 0;
  int _totalScore = 0;

  final List<LevelConfig> _levels = [];

  Future<void> initialize() async {
    _levels.addAll(await loadLevels());
  }

  void nextLevel(int levelScore) {
    _totalScore += levelScore;
    currentLevel++;
    print('now level!!!!!!!!!!!!!!!!');
    print(currentLevel);
  }

  LevelConfig getCurrentLevelConfig() => _levels[currentLevel];

  bool isLastLevel() => currentLevel + 1 == _levels.length;

  int get totalScore => _totalScore;
}
