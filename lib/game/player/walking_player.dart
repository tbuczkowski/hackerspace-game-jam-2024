import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:hackerspace_game_jam_2024/game/npc/enemies.dart';
import 'package:hackerspace_game_jam_2024/game/player/player.dart';

class WalkingPlayer extends Player {
  static const double jumpHeight = 300;
  static const double jumpDistance = 250;
  static const double acceleration = 300;

  bool jumpIsPressed = false;

  WalkingPlayer({required super.position});

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    horizontalDirection +=
        (keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft)) ? -1 : 0;
    horizontalDirection +=
        (keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight)) ? 1 : 0;
    jumpIsPressed = keysPressed.contains(LogicalKeyboardKey.space);
    if (jumpTime == null && isOnGround) {
      jumpTime = jumpIsPressed ? 0 : null;
      jump(jumpHeight);
    }
    return true;
  }

  void jump(double jumpHeight) {
    if (jumpTime != null) {
      final double horizontalComponent = clampDouble(velocity.x.abs(), 250, 350);
      velocity.y = (-2 * jumpHeight * horizontalComponent) / (jumpDistance);
      isOnGround = false;
    }
  }

  @override
  void update(double dt) {
    final bool acceleratingInOppositeDirection =
        velocity.x.sign != horizontalDirection.sign && horizontalDirection != 0;
    final bool shouldDecelerate = horizontalDirection == 0 && velocity.x != 0;
    velocity.x += horizontalDirection * acceleration * (acceleratingInOppositeDirection ? 3.5 : 1) * dt;
    velocity.x -=
        shouldDecelerate ? (acceleration * 1.5 * dt).clamp(-velocity.x.abs(), velocity.x.abs()) * velocity.x.sign : 0;
    velocity.x = clampDouble(velocity.x, -maxXSpeed, maxXSpeed);
    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    final double horizontalComponent = clampDouble(velocity.x.abs(), 250, 300);

    final double gravity = (2 * jumpHeight * horizontalComponent * horizontalComponent) / (jumpDistance * jumpDistance);

    if (jumpTime != null) {
      jumpTime = jumpTime! + dt;
    }
    velocity.y += gravity * dt + ((!jumpIsPressed) ? gravity : -0.1 * gravity) * dt;
    position += velocity * dt;

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is WaterEnemy && !iframesActive && intersectionPoints.length == 2) {
      final Vector2 mid = (intersectionPoints.elementAt(0) + intersectionPoints.elementAt(1)) / 2;

      final collisionNormal = absoluteCenter - mid;
      final separationDistance = (size.x / 2) - collisionNormal.length;
      collisionNormal.normalize();

      // If collision normal is almost upwards,
      // ember must be on ground.
      print(velocity);
      if (Vector2(0, -1).dot(collisionNormal) > 0.8 && velocity.y > 100 && position.y < other.position.y) {
        other.kill();
        jumpTime = 0;
        jump(jumpHeight / 2);
        return;
      }
    }

    super.onCollision(intersectionPoints, other);
  }
}
