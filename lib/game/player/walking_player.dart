import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:hackerspace_game_jam_2024/audio/sounds.dart';
import 'package:hackerspace_game_jam_2024/game/npc/base_enemy.dart';
import 'package:hackerspace_game_jam_2024/game/npc/enemies.dart';
import 'package:hackerspace_game_jam_2024/game/npc/mah_yntelygent_enemy.dart';
import 'package:hackerspace_game_jam_2024/game/player/player.dart';

class WalkingPlayer extends Player {
  static const double jumpHeight = 300;
  static const double jumpDistance = 250;
  static const double acceleration = 300;

  bool jumpIsPressed = false;

  WalkingPlayer({required super.gridPosition});

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final int prevDirection = horizontalDirection;
    horizontalDirection = 0;
    if (!lockControls) {
      horizontalDirection +=
          (keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft))
              ? -1
              : 0;
      horizontalDirection +=
          (keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight))
              ? 1
              : 0;

      if (prevDirection.sign != horizontalDirection.sign &&
          horizontalDirection != 0 &&
          velocity.x.abs() > 100 &&
          isOnGround) {
        game.audioController.playSfx(SfxType.slide);
      }
      final bool wasJumpPressed = jumpIsPressed;
      jumpIsPressed = keysPressed.contains(LogicalKeyboardKey.space);
      if (!wasJumpPressed && jumpTime == null && isOnGround) {
        jumpTime = jumpIsPressed ? 0 : null;
        jump(jumpHeight);
      }
    }
    return true;
  }

  void jump(double jumpHeight) {
    if (jumpTime != null && game.health > 0) {
      game.audioController.playSfx(SfxType.jump);
      final double horizontalComponent = clampDouble(velocity.x.abs(), 250, 350);
      velocity.y = (-2 * jumpHeight * horizontalComponent) / (jumpDistance);
      isOnGround = false;
    }
  }

  @override
  void update(double dt) {
    if (game.health > 0 && position.y > 1000) {
      game.health = 0;
    }
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
    if (other is BaseEnemy && !iframesActive && intersectionPoints.length == 2) {
      final Vector2 mid = (intersectionPoints.elementAt(0) + intersectionPoints.elementAt(1)) / 2;

      final collisionNormal = absoluteCenter - mid;
      collisionNormal.normalize();

      // If collision normal is almost upwards,
      // ember must be on ground.
      if (Vector2(0, -1).dot(collisionNormal) > 0.8 &&
          velocity.y > 100 &&
          position.y < other.position.y &&
          other.children.whereType<RectangleHitbox>().isNotEmpty) {
        other.kill();
        jumpTime = 0;
        jump(jumpHeight / 2);
        return;
      }
    }

    super.onCollision(intersectionPoints, other);
  }
}
