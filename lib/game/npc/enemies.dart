import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:hackerspace_game_jam_2024/game/block.dart';
import 'package:hackerspace_game_jam_2024/game/npc/base_enemy.dart';

class KozakEnemy extends BaseEnemy {

  static const double acceleration = 300;

  late final SpriteAnimationComponent spriteAnimationComponent;

  KozakEnemy({
    required super.gridPosition,
  });

  @override
  void onLoad() {
    spriteAnimationComponent = SpriteAnimationComponent(
        size: Vector2.all(64 * 1.5),
        position: Vector2(-16, 64),
        anchor: Anchor.bottomLeft,
        animation: SpriteAnimation.fromFrameData(
          game.images.fromCache('enemy/Walk.png'),
          SpriteAnimationData.sequenced(
              amount: 6, textureSize: Vector2.all(48), stepTime: 0.70, texturePosition: Vector2(-10, 0)),
        ));
    position = Vector2(
      (gridPosition.x * size.x),
      game.size.y - (gridPosition.y * size.y),
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
    add(CircleHitbox());
    add(spriteAnimationComponent);
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
    if (children.whereType<RectangleHitbox>().isNotEmpty) {
      velocity.y += 1200 * dt;
    } else {
      velocity = Vector2.zero();
    }

    position += velocity * dt;

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (isTerrain(other) && intersectionPoints.length == 2) {
      onTerrainCollision(intersectionPoints);
    }

    super.onCollision(intersectionPoints, other);
  }
}
