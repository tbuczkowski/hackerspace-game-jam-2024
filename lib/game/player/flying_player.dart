import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:hackerspace_game_jam_2024/game/block.dart';
import 'package:hackerspace_game_jam_2024/game/enemies.dart';
import 'package:hackerspace_game_jam_2024/game/gate.dart';
import 'package:hackerspace_game_jam_2024/game/player/player.dart';
import 'package:hackerspace_game_jam_2024/game/star.dart';

class FlyingPlayer extends Player {

  static const flyingSpeed = -100;

  FlyingPlayer({required super.position});

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;

    return true;
  }

  @override
  void update(double dt) {
    velocity.x = horizontalDirection * maxXSpeed;
    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    velocity.y += flyingSpeed * dt;
    position += velocity * dt;

    super.update(dt);
  }

  // Repeatedly hitting ceiling when traveling at speed is not good for the health...
  @override
  bool shouldReceiveHit(PositionComponent other) => super.shouldReceiveHit(other) || isTerrain(other);
}
