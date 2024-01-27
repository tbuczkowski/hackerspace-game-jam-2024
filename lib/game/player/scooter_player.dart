import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:hackerspace_game_jam_2024/game/block.dart';
import 'package:hackerspace_game_jam_2024/game/player/player.dart';
import 'package:hackerspace_game_jam_2024/game/ui/money.dart';

class ScooterPlayer extends Player {
  int verticalDirection = 0;
  static const ridingSpeed = 100;
  final double maxYSpeed = 20;

  ScooterPlayer({required super.position});

  late SpriteComponent hulajkaComponent;

  @override
  Future<void> onLoad() async {
    final hulajka = await game.loadSprite(
      'hulajka.png',
      srcSize: Vector2(201, 205),
    );

    hulajkaComponent = SpriteComponent(
      size: Vector2(64, 64),
      sprite: hulajka,
      position: Vector2(32 + 4, 32 + 4),
      anchor: Anchor.center,
    );
    add(hulajkaComponent);

    return super.onLoad();
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    verticalDirection = 0;
    verticalDirection +=
        (keysPressed.contains(LogicalKeyboardKey.keyW) || keysPressed.contains(LogicalKeyboardKey.arrowUp)) ? -1 : 0;
    verticalDirection +=
        (keysPressed.contains(LogicalKeyboardKey.keyS) || keysPressed.contains(LogicalKeyboardKey.arrowDown)) ? 1 : 0;

    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (leaveLevel(other)) {
      return;
    }

    if (isTerrain(other) && intersectionPoints.length == 2) {
      onTerrainCollision(intersectionPoints);
    }

    if (shouldReceiveHit(other)) {
      velocity.x = 0;
      hit();
    }

    if (other is Money) {
      other.removeFromParent();
      game.currentScore++;
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void update(double dt) {
    if (velocity.x < maxXSpeed) {
      velocity.x += ridingSpeed * dt;
    }
    velocity.y += verticalDirection * maxYSpeed;
    velocity.y = velocity.y.clamp(-500, 500);
    position += velocity * dt;

    super.update(dt);

    final angle = 0.1 * pi * velocity.y / 500;
    hulajkaComponent.angle = angle;
    spriteAnimationComponent.angle = angle;

    spriteAnimationComponent.animation = jumpAnimation;
  }

  // Repeatedly hitting ceiling when traveling at speed is not good for the health...
  @override
  bool shouldReceiveHit(PositionComponent other) => super.shouldReceiveHit(other) || isTerrain(other);
}
