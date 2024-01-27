import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';

class Money extends SpriteAnimationComponent with HasGameReference<ASDGame> {
  final Vector2 gridPosition;

  final Vector2 velocity = Vector2.zero();

  Money({
    required this.gridPosition,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Money.png'),
      SpriteAnimationData.sequenced(
          amount: 6,
          textureSize: Vector2.all(24),
          stepTime: 0.50,
      ),
    );
    position = Vector2(
      (gridPosition.x * size.x) + (size.x / 2),
      game.size.y - (gridPosition.y * size.y) - (size.y / 2),
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
    add(
      SizeEffect.by(
        Vector2(-24, -24),
        EffectController(
          duration: .75,
          reverseDuration: .5,
          infinite: true,
          curve: Curves.easeOut,
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;

    super.update(dt);
  }
}
