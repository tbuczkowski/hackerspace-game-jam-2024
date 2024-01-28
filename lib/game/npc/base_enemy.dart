import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:hackerspace_game_jam_2024/audio/sounds.dart';
import 'package:hackerspace_game_jam_2024/game/block.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';

class BaseEnemy extends PositionComponent with HasGameReference<ASDGame>, CollisionCallbacks {
  final Vector2 gridPosition;

  bool isDead = false;

  Vector2 velocity = Vector2.zero();

  final double maxXSpeed = 100;
  static const double acceleration = 300;

  int horizontalDirection = -1;

  late final SpriteAnimationComponent spriteAnimationComponent;

  BaseEnemy({
    required this.gridPosition,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

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
