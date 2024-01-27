import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackerspace_game_jam_2024/game/block.dart';
import 'package:hackerspace_game_jam_2024/game/hud.dart';
import 'package:hackerspace_game_jam_2024/game/level/level_config.dart';
import 'package:hackerspace_game_jam_2024/game/level/level_factory.dart';
import 'package:hackerspace_game_jam_2024/game/level/level_painter.dart';
import 'package:hackerspace_game_jam_2024/game/level/levels.dart';
import 'package:hackerspace_game_jam_2024/game/player.dart';

import 'background_component.dart';

class ASDGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late final Player _player;
  late final CameraTarget _cameraTarget;

  double objectSpeed = 0.0;
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;
  late Level level;
  late LevelPainter _levelPainter;
  int starsCollected = 0;
  int health = 3;

  String currentLevel;

  final LevelFactory _levelFactory = LevelFactory(LevelFactoryConfig.build());

  ASDGame(this.currentLevel);

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
      'ember.png',
      'ground.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
      'wall.png',
      'gate.png',
      'hobo.png',
    ]);

    initializeGame();

    return super.onLoad();
  }

  Future<void> loadLevel() async {
    print("Loading level $currentLevel");
    try {
      final LevelConfig levelConfig =
          await LevelConfig.load('assets/levels/$currentLevel.json');
      level = await _levelFactory.build(levelConfig);
    } catch (ex) {
      level = demoLevel;
      print(ex);
    }
  }

  Future<void> initializeGame() async {
    await loadLevel();

    // Assume that size.x < 3200
    final segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad.clamp(0, level.blocks.length);

    _levelPainter.paintLevel(level);

    _player = Player(
      position: Vector2(128, 128),
    );
    _cameraTarget = CameraTarget(player: _player);

    world.add(_player);
    world.add(_cameraTarget);
    camera.viewport.add(Hud());
    camera.follow(_cameraTarget, maxSpeed: 1000);
    camera.viewfinder.anchor = Anchor.center;

    add(BackgroundComponent());
  }

  void changeLevel() async {
    //
    if (currentLevel == Levels.ENTRY) {
      GoRouter.of(buildContext!)
          .pushReplacement('/game_page/${Levels.TOWER}');
    } else {
      print('The end');
    }
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
    position = player.position +
        Vector2(100 * (player.velocity.x / player.maxXSpeed), 0);
    position = Vector2(position.x, position.y.clamp(-double.infinity, 400));
    super.update(dt);
  }
}
