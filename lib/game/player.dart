import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';
import 'package:hackerspace_game_jam_2024/game/block.dart';
import 'package:hackerspace_game_jam_2024/game/enemies.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';
import 'package:hackerspace_game_jam_2024/game/gate.dart';
import 'package:hackerspace_game_jam_2024/game/star.dart';

class Player extends SpriteAnimationComponent with KeyboardHandler, CollisionCallbacks, HasGameReference<ASDGame> {
  final Vector2 velocity = Vector2.zero();
  final double maxXSpeed = 300;
  static const double jumpHeight = 250;
  static const double jumpDistance = 150;
  final PositionComponent cameraFocusComponent = PositionComponent(position: Vector2(0, 1));

  double? jumpTime;
  bool isOnGround = false;
  int horizontalDirection = 0;
  bool hitByEnemy = false;

  Player({
    required super.position,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('ember.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(16),
        stepTime: 0.12,
      ),
    );
    add(CircleHitbox());
    add(cameraFocusComponent);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    horizontalDirection +=
        (keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft)) ? -1 : 0;
    horizontalDirection +=
        (keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight)) ? 1 : 0;
    if (jumpTime == null && isOnGround) {
      jumpTime = keysPressed.contains(LogicalKeyboardKey.space) ? 0 : null;
      if (jumpTime != null) {
        final double horizontalComponent = clampDouble(velocity.x.abs(), 250, 300);
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

    final double gravity = (2 * jumpHeight * horizontalComponent * horizontalComponent) / (jumpDistance * jumpDistance);

    if (jumpTime != null) {
      jumpTime = jumpTime! + dt;
    }
    velocity.y += gravity * dt;
    position += velocity * dt;

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (isTerrain(other)) {
      if (intersectionPoints.length == 2) {
        // Calculate the collision normal and separation distance.
        final Vector2 mid = (intersectionPoints.elementAt(0) + intersectionPoints.elementAt(1)) / 2;

        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        // If collision normal is almost upwards,
        // ember must be on ground.
        if (Vector2(0, -1).dot(collisionNormal) > 0.9) {
          isOnGround = true;
          jumpTime = null;
          velocity.y = 0;
        }
        if (Vector2(0, 1).dot(collisionNormal) > 0.9) {
          velocity.y = 0;
        }

        // Resolve collision by moving ember along
        // collision normal by separation distance.
        position += collisionNormal.scaled(separationDistance);
      }
    }

    if (other is Gate) {
      game.changeLevel();
    }

    if (other is Star) {
      other.removeFromParent();
    }

    if (other is WaterEnemy) {
      hit();
    }

    if (other is Star) {
      other.removeFromParent();
      game.starsCollected++;
    }
    super.onCollision(intersectionPoints, other);
  }

  // This method runs an opacity effect on ember
// to make it blink.
  void hit() {
    if (!hitByEnemy) {
      game.health--;
      hitByEnemy = true;
    }
    add(
      OpacityEffect.fadeOut(
        EffectController(
          alternate: true,
          duration: 0.1,
          repeatCount: 5,
        ),
      )..onComplete = () {
          hitByEnemy = false;
        },
    );
  }
}
