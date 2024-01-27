
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:hackerspace_game_jam_2024/game/block.dart';
import 'package:hackerspace_game_jam_2024/game/npc/enemies.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';
import 'package:hackerspace_game_jam_2024/game/terrain/gate.dart';
import 'package:hackerspace_game_jam_2024/game/ui/star.dart';

class Player extends SpriteAnimationComponent with KeyboardHandler, CollisionCallbacks, HasGameReference<ASDGame> {
  final Vector2 velocity = Vector2.zero();
  final double maxXSpeed = 300;

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
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (leaveLevel(other)) {
      return;
    }

    if (isTerrain(other) && intersectionPoints.length == 2) {
      onTerrainCollision(intersectionPoints);
    }

    if (shouldReceiveHit(other)) {
      hit();
    }

    if (other is Star) {
      other.removeFromParent();
      game.currentScore++;
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

  bool leaveLevel(PositionComponent other) {
    if (other is Gate) {
      game.changeLevel();
      return true;
    }

    return false;
  }

  bool shouldReceiveHit(PositionComponent other) => other is WaterEnemy;

  // This method runs an opacity effect on ember to make it blink.
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
