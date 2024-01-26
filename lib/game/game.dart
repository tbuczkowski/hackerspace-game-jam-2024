import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:hackerspace_game_jam_2024/game/block.dart';
import 'package:hackerspace_game_jam_2024/game/enemies.dart';
import 'package:hackerspace_game_jam_2024/game/ground_block.dart';
import 'package:hackerspace_game_jam_2024/game/hud.dart';
import 'package:hackerspace_game_jam_2024/game/platform_block.dart';
import 'package:hackerspace_game_jam_2024/game/player.dart';
import 'package:hackerspace_game_jam_2024/game/star.dart';

class ASDGame extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Player _player;
  double objectSpeed = 0.0;
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;
  int starsCollected = 0;
  int health = 3;

  ASDGame();

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

  @override
  bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'block.png',
      'ember.png',
      'ground.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
    ]);

    camera.viewfinder.anchor = Anchor.topLeft;

    initializeGame();
  }

  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    for (final block in segments[segmentIndex]) {
      switch (block.blockType) {
        case GroundBlock:
          world.add(
            GroundBlock(
              gridPosition: block.gridPosition,
              xOffset: xPositionOffset,
            ),
          );
          break;
        case PlatformBlock:
          add(PlatformBlock(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
        case Star:
          world.add(
            Star(
              gridPosition: block.gridPosition,
              xOffset: xPositionOffset,
            ),
          );
          break;
        case WaterEnemy:
          world.add(
            WaterEnemy(
              gridPosition: block.gridPosition,
              xOffset: xPositionOffset,
            ),
          );
          break;
      }
    }
  }

  void initializeGame() {
    // Assume that size.x < 3200
    final segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i <= segmentsToLoad; i++) {
      loadGameSegments(i, (640 * i).toDouble());
    }

    _player = Player(
      position: Vector2(128, canvasSize.y - 256),
    );
    world.add(_player);
    camera.viewport.add(Hud());
  }
}
