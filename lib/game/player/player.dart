import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:hackerspace_game_jam_2024/game/block.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';
import 'package:hackerspace_game_jam_2024/game/npc/enemies.dart';
import 'package:hackerspace_game_jam_2024/game/terrain/gate.dart';
import 'package:hackerspace_game_jam_2024/game/ui/star.dart';

class Player extends SpriteAnimationComponent with KeyboardHandler, CollisionCallbacks, HasGameReference<ASDGame> {
  final Vector2 velocity = Vector2.zero();
  final double maxXSpeed = 500;

  bool lockControls = false;

  final PositionComponent cameraFocusComponent = PositionComponent(position: Vector2(0, 1));

  double? jumpTime;
  bool isOnGround = false;
  int horizontalDirection = 0;
  bool iframesActive = false;

  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _jumpAnimation;
  late final SpriteAnimation _flinchAnimation;

  Player({
    required super.position,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    animation = updateAnimation();
  }

  SpriteAnimation updateAnimation() {
    const int movementThreshold = 50;
    if(iframesActive) return _flinchAnimation;
    if(velocity.y.abs() > movementThreshold) return _jumpAnimation;
    if(velocity.x.abs() > movementThreshold) return _runAnimation;
    return _idleAnimation;
  }

  @override
  Future<void> onLoad() async {
    _runAnimation = loadAnimation('character/run.png', 6);
    _idleAnimation = loadAnimation('character/idle.png', 4, positionOffset: Vector2(-5, 0));
    _flinchAnimation = loadAnimation('character/hurt.png', 2);
    _jumpAnimation = loadAnimation('character/jump.png', 4);
    animation = _idleAnimation;

    add(CircleHitbox(radius: 48 / 2, position: Vector2(0, 16)));
    add(cameraFocusComponent);
  }

  SpriteAnimation loadAnimation(String path, int numberOfFrames, {Vector2? positionOffset}) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(path),
      SpriteAnimationData.sequenced(
        amount: numberOfFrames,
        textureSize: Vector2.all(48),
        stepTime: 0.12,
        texturePosition: positionOffset,
      ),
    );
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
    if (!iframesActive) {
      game.health--;
      iframesActive = true;
      add(
        OpacityEffect.fadeOut(
          EffectController(
            alternate: true,
            duration: 0.1,
            repeatCount: 5,
          ),
        )..onComplete = () {
            iframesActive = false;
          },
      );
    }
  }
}
