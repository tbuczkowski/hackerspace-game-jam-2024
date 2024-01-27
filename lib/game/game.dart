import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackerspace_game_jam_2024/game/block.dart';
import 'package:hackerspace_game_jam_2024/game/game_state.dart';
import 'package:hackerspace_game_jam_2024/game/level/level_config.dart';
import 'package:hackerspace_game_jam_2024/game/level/level_factory.dart';
import 'package:hackerspace_game_jam_2024/game/level/level_painter.dart';
import 'package:hackerspace_game_jam_2024/game/player/player.dart';
import 'package:hackerspace_game_jam_2024/game/ui/hud.dart';

import 'background_component.dart';

class ASDGame extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  late final Player _player;
  late final CameraTarget _cameraTarget;
  late final GameState _gameState;

  double objectSpeed = 0.0;
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;
  late Level level;
  late LevelPainter _levelPainter;
  int currentScore = 0;
  int _health = 3;

  int get health => _health;
  set health(int value) {
    _health = value;
    if (_health == 0) {
      launchGameOver();
    }
  }

  final LevelFactory _levelFactory = LevelFactory(LevelFactoryConfig.build());

  ASDGame();

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

  @override
  bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    _levelPainter = LevelPainter(gameRef: this);

    await images.loadAll([
      'block.png',
      'ground.png',
      'star.png',
      'water_enemy.png',
      'wall.png',
      'gate.png',
      'hobo.png',
      'character/run.png',
      'character/idle.png',
      'character/hurt.png',
      'character/jump.png',
      'specek.png',
      'zbita_butelka.png',
      'enemy/Walk.png'
    ]);

    await initializeGame();

    return super.onLoad();
  }

  Future<void> loadLevel() async {
    try {
      _gameState = await GameState.getInstance();
      final LevelConfig levelConfig = _gameState.getCurrentLevelConfig();

      print("Loading level ${_gameState.getCurrentLevelConfig().filename}");
      level = await _levelFactory.build(levelConfig);
    } catch (ex) {
      level = demoLevel;
      print(ex);
    }
  }

  Future<void> initializeGame() async {
    await loadLevel();

    _levelPainter.paintLevel(level);
    _player = _levelPainter.paintPlayer(level);

    _cameraTarget = CameraTarget(player: _player);
    world.add(_cameraTarget);
    camera.viewfinder.zoom = 0.8;
    camera.viewport.add(Hud());
    camera.follow(_cameraTarget, maxSpeed: 1000);
    camera.viewfinder.anchor = Anchor.center;

    add(BackgroundComponent());
  }

  void changeLevel() async {
    if (_gameState.isLastLevel()) {
      GameState.reset();
      GoRouter.of(buildContext!).replace('/');
    } else {
      _gameState.nextLevel(currentScore);
      GoRouter.of(buildContext!).replace('/game_page');
    }
  }

  void launchGameOver() {
    _player.lockControls = true;
    overlays.add('you_died');
  }
}

class CameraTarget extends PositionComponent with HasGameRef<ASDGame> {
  final Player player;

  CameraTarget({
    super.position,
    required this.player,
  });

  @override
  void update(double dt) {
    position = player.position + Vector2(100 * (player.velocity.x / player.maxXSpeed), 0);
    position = Vector2(position.x, position.y.clamp(-double.infinity, 400));
    super.update(dt);
  }
}
