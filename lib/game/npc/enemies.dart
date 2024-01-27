import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/foundation.dart';
import 'package:hackerspace_game_jam_2024/game/block.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';

class WaterEnemy extends SpriteAnimationComponent with HasGameReference<ASDGame>, CollisionCallbacks {
  final Vector2 gridPosition;

  Vector2 velocity = Vector2.zero();

  final double maxXSpeed = 100;
  static const double acceleration = 300;

  int horizontalDirection = -1;

  WaterEnemy({
    required this.gridPosition,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('water_enemy.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2.all(16),
        stepTime: 0.70,
      ),
    );
    position = Vector2(
      (gridPosition.x * size.x),
      game.size.y - (gridPosition.y * size.y),
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
    add(CircleHitbox());
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
      velocity.y += 400 * dt;
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

  void onTerrainCollision(Set<Vector2> intersectionPoints) {
    // Calculate the collision normal and separation distance.
    final Vector2 mid = (intersectionPoints.elementAt(0) + intersectionPoints.elementAt(1)) / 2;

    final collisionNormal = absoluteCenter - mid;
    final separationDistance = (size.x / 2) - collisionNormal.length;
    collisionNormal.normalize();

    // If collision normal is almost upwards,
    // ember must be on ground.
    if (Vector2(0, -1).dot(collisionNormal) > 0.9) {
      velocity.y = 0;
    }

    // Resolve collision by moving ember along
    // collision normal by separation distance.
    position += collisionNormal.scaled(separationDistance);
  }

  void kill() {
    final Component hitbox = children.firstWhere((element) => element is RectangleHitbox);
    removeWhere((component) => component is ShapeHitbox);
    add(ScaleEffect.by(
      Vector2(1.7, 0.12),
      EffectController(
        duration: 0.07,
      ),
    ));
    add(MoveByEffect(
      Vector2(0, 6),
      EffectController(
        duration: 0.07,
      ),
    ));
  }
}
