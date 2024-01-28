import 'package:audioplayers/audioplayers.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackerspace_game_jam_2024/audio/audio_controller.dart';
import 'package:hackerspace_game_jam_2024/audio/sounds.dart';
import 'package:hackerspace_game_jam_2024/game/block.dart';
import 'package:hackerspace_game_jam_2024/game/game_state.dart';
import 'package:hackerspace_game_jam_2024/game/level/level_config.dart';
import 'package:hackerspace_game_jam_2024/game/level/level_factory.dart';
import 'package:hackerspace_game_jam_2024/game/level/level_painter.dart';
import 'package:hackerspace_game_jam_2024/game/player/player.dart';
import 'package:hackerspace_game_jam_2024/game/player/scooter_player.dart';
import 'package:hackerspace_game_jam_2024/game/player/walking_player.dart';
import 'package:hackerspace_game_jam_2024/game/terrain/base_terrain.dart';
import 'package:hackerspace_game_jam_2024/game/ui/hud.dart';

import 'background_component.dart';

class ASDGame extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  final AudioController audioController;
  late final Player _player;
  late final CameraTarget _cameraTarget;
  late final GameState _gameState;

  double objectSpeed = 0.0;
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;
  late Level level;
  late LevelPainter _levelPainter;
  int currentScore = 0;
  int currentFrogPoints = 0;
  static const int maxHealth = 5;
  int _health = maxHealth;
  Stopwatch timer = Stopwatch();
  late int timeLeft = _gameState.timeLeft;

  int get health => _health;

  set health(int value) {
    _health = value;
    if (_health == 0) {
      launchGameOver();
    }
  }

  final LevelFactory _levelFactory = LevelFactory(LevelFactoryConfig.build());

  ASDGame(this.audioController);

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

  @override
  bool get debugMode => false;

  @override
  Future<void> onLoad() async {
    _levelPainter = LevelPainter(gameRef: this);

    await images.loadAll([
      'block.png',
      'ground.png',
      'Money.png',
      'static_money.png',
      'wall.png',
      'gate.png',
      'frogshop.png',
      'hobo.png',
      'character/run.png',
      'character/idle.png',
      'character/hurt.png',
      'character/jump.png',
      'specek.png',
      'zbita_butelka.png',
      'enemy/Walk.png',
      'shop/monsterek.png',
      'shop/specek.png',
      'shop/szlugi.png'
    ]);

    await initializeGame();

    return super.onLoad();
  }

  final List songs = [
    AssetSource('music/level1.mp3'),
    AssetSource('music/scooter_level.mp3'),
  ];

  Future<void> loadLevel() async {
    try {
      _gameState = await GameState.getInstance();
      final LevelConfig levelConfig = _gameState.getCurrentLevelConfig();
      print(songs[_gameState.currentLevel % songs.length]);
      await audioController.musicPlayer.stop();
      audioController.musicPlayer.setReleaseMode(ReleaseMode.loop);
      audioController.musicPlayer.play(songs[_gameState.currentLevel % songs.length]);

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
    timer.start();
  }

  void changeLevel() async {
    if (_gameState.isLastLevel()) {
      GameState.reset();
      GoRouter.of(buildContext!).replace('/outro');
    } else {
      pauseEngine();
      _gameState.timeLeft = timeLeft;
      _gameState.nextLevel(currentScore);
      overlays.add('frog_shop');
    }
  }

  void launchGameOver() {
    audioController.playSfx(SfxType.yoda);
    _player.lockControls = true;
    _player.removeWhere((c) => c is ShapeHitbox);
    _player.jumpTime = 0;
    if (_player is WalkingPlayer) {
      (_player as WalkingPlayer).jump(WalkingPlayer.jumpHeight * 0.5);
    }
    Future.delayed(Duration(milliseconds: 750)).then((_) {
      overlays.add('you_died');
    });
  }

  @override
  void update(double dt) {
    timeLeft = _gameState.timeLeft - timer.elapsed.inSeconds;
    if (timeLeft <= 0) {
      launchGameOver();
      //todo mby different gameover overlay from MGS?
    }
    if (_player is ScooterPlayer) {
      handleScooterCollision();
    }
    super.update(dt);
  }

  void handleScooterCollision() {
    final ray = Ray2(origin: _player.position, direction: Vector2(1, 0)..normalize());
    final result = collisionDetection.raycast(ray, maxDistance: 32);
    if (result != null && result.hitbox?.parent is BaseTerrain) {
      _player.velocity.x = 0;
      _player.position -= Vector2(100, 0);
      _player.hit();
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
    position = player.position + Vector2(100 * (player.velocity.x / player.maxXSpeed), 0);
    position = Vector2(position.x, position.y.clamp(-double.infinity, 400));
    super.update(dt);
  }
}
