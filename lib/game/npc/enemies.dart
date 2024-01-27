import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/foundation.dart';
import 'package:hackerspace_game_jam_2024/audio/sounds.dart';
import 'package:hackerspace_game_jam_2024/game/block.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';
import 'package:hackerspace_game_jam_2024/game/level/level_config.dart';
import 'package:hackerspace_game_jam_2024/game/terrain/base_terrain.dart';
import 'package:hackerspace_game_jam_2024/game/terrain/gate.dart';

class KozakEnemy extends PositionComponent with HasGameReference<ASDGame>, CollisionCallbacks {
  final Vector2 gridPosition;

  bool isDead = false;

  Vector2 velocity = Vector2(maxXSpeed, 0);

  static const double maxXSpeed = 100;
  static const double acceleration = 300;
  final EnemyMovementDef? movementDef;

  int horizontalDirection = -1;

  late final SpriteAnimationComponent spriteAnimationComponent;

  KozakEnemy({required this.gridPosition, this.movementDef}) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

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
    _OffendingDirection? boundsCheck = _canMove();

    if (boundsCheck != null) {
      print("BoundCheck failed, next horizontal direction is ${boundsCheck.horizontalDirection}");
      horizontalDirection = boundsCheck.horizontalDirection;
    }

    // final bool acceleratingInOppositeDirection =
    //     velocity.x.sign != horizontalDirection.sign && horizontalDirection != 0;
    // final bool shouldDecelerate = horizontalDirection == 0 && velocity.x != 0;
    // velocity.x += horizontalDirection * acceleration * (acceleratingInOppositeDirection ? 3.5 : 1) * dt;
    // velocity.x -=
    //     shouldDecelerate ? (acceleration * 1.5 * dt).clamp(-velocity.x.abs(), velocity.x.abs()) * velocity.x.sign : 0;
    // velocity.x = clampDouble(velocity.x, -maxXSpeed, maxXSpeed);

    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    velocity.x = horizontalDirection * maxXSpeed;

    if (!isDead) {
      position += velocity * dt.abs();
    }

    print("Enemy pos: $position, velocity: $velocity");

    super.update(dt);
  }

  _OffendingDirection? _canMove() {
    if (movementDef == null) {
      return null;
    }

    if (position.x <= ((movementDef!.leftXBoundary + 1) * size.x)) {
      return _OffendingDirection.left;
    }

    if (position.x >= ((movementDef!.rightXBoundary - 1) * size.x)) {
      return _OffendingDirection.right;
    }

    return null;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if ((isTerrain(other) || other is NPCMovementLimiter || other is FrogshopBackground) &&
        intersectionPoints.length == 2) {
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

    // Turn around after collision in x-plane
    if (Vector2(1, 0).dot(collisionNormal).abs() > 0.9) {
      horizontalDirection *= -1;
    }

    // Resolve collision by moving ember along
    // collision normal by separation distance.
    position += collisionNormal.scaled(separationDistance);
  }

  void kill() {
    isDead = true;
    game.audioController.playSfx(SfxType.bonk);
    removeWhere((component) => component is ShapeHitbox);
    add(ScaleEffect.by(
      Vector2(1.8, 0.23),
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

enum _OffendingDirection {
  left(1),
  right(-1);

  final int horizontalDirection;

  const _OffendingDirection(this.horizontalDirection);
}
