import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:hackerspace_game_jam_2024/game/player/player.dart';

class WalkingPlayer extends Player {
  static const double jumpHeight = 250;
  static const double jumpDistance = 150;

  WalkingPlayer({required super.position});

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
    if (jumpTime == null && isOnGround) {
      jumpTime = keysPressed.contains(LogicalKeyboardKey.space) ? 0 : null;
      if (jumpTime != null) {
        final double horizontalComponent =
            clampDouble(velocity.x.abs(), 250, 300);
        velocity.y = (-2 * jumpHeight * horizontalComponent) / (jumpDistance);
        isOnGround = false;
      }
    }
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

    final double horizontalComponent = clampDouble(velocity.x.abs(), 250, 300);

    final double gravity =
        (2 * jumpHeight * horizontalComponent * horizontalComponent) /
            (jumpDistance * jumpDistance);

    if (jumpTime != null) {
      jumpTime = jumpTime! + dt;
    }
    velocity.y += gravity * dt;
    position += velocity * dt;

    super.update(dt);
  }
}
