import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:hackerspace_game_jam_2024/audio/sounds.dart';
import 'package:hackerspace_game_jam_2024/game/block.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';
import 'package:hackerspace_game_jam_2024/game/npc/enemies.dart';
import 'package:hackerspace_game_jam_2024/game/terrain/gate.dart';
import 'package:hackerspace_game_jam_2024/game/ui/money.dart';

class Player extends PositionComponent with KeyboardHandler, CollisionCallbacks, HasGameReference<ASDGame> {
  final Vector2 velocity = Vector2.zero();
  final double maxXSpeed = 500;

  bool lockControls = false;

  final PositionComponent cameraFocusComponent = PositionComponent(position: Vector2(0, 1));
  late final SpriteAnimationComponent spriteAnimationComponent;

  double? jumpTime;
  bool isOnGround = false;
  int horizontalDirection = 0;
  bool iframesActive = false;

  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation jumpAnimation;
  late final SpriteAnimation _flinchAnimation;

  Player({
    required super.position,
  }) : super(size: Vector2.all(64), anchor: Anchor.center) {
    spriteAnimationComponent = SpriteAnimationComponent(
      // size: size,
      size: Vector2.all(64 * 1.5),
      position: Vector2(32 + 10, 16),
      anchor: Anchor.center,
      // position: position,
    );
  }

  @override
  void update(double dt) {
    spriteAnimationComponent.animation = updateAnimation();
    if (spriteAnimationComponent.animation == _runAnimation) {
      spriteAnimationComponent.animationTicker!.onFrame = (int currentIndex) {
        if ((currentIndex - 1) % 3 == 0) {
          game.audioController.playSfx(SfxType.step);
        }
      };
    }
    super.update(dt);
  }

  SpriteAnimation updateAnimation() {
    const int movementThreshold = 50;
    if (iframesActive) return _flinchAnimation;
    if (velocity.y.abs() > movementThreshold) return jumpAnimation;
    if (velocity.x.abs() > movementThreshold) return _runAnimation;
    return _idleAnimation;
  }

  @override
  Future<void> onLoad() async {
    _runAnimation = loadAnimation('character/run.png', 6);
    _idleAnimation = loadAnimation('character/idle.png', 4, positionOffset: Vector2(-5, 0));
    _flinchAnimation = loadAnimation('character/hurt.png', 2, positionOffset: Vector2(-5, 0));
    jumpAnimation = loadAnimation('character/jump.png', 4, loop: false);
    spriteAnimationComponent.animation = _idleAnimation;

    add(CircleHitbox(radius: 48 / 2, position: Vector2(8, 16)));
    add(spriteAnimationComponent);
    add(cameraFocusComponent);
  }

  SpriteAnimation loadAnimation(
    String path,
    int numberOfFrames, {
    Vector2? positionOffset,
    bool loop = true,
  }) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(path),
      SpriteAnimationData.sequenced(
        amount: numberOfFrames,
        textureSize: Vector2.all(48),
        stepTime: 0.12,
        texturePosition: positionOffset,
        loop: loop,
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

    if (other is Money) {
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
      if (!isOnGround) {
        game.audioController.playSfx(SfxType.step);
      }
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

  bool shouldReceiveHit(PositionComponent other) => other is KozakEnemy && !other.isDead;

  // This method runs an opacity effect on ember to make it blink.
  void hit() {
    if (!iframesActive) {
      game.audioController.playSfx(SfxType.pain);
      game.health--;
      iframesActive = true;
      spriteAnimationComponent.add(
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
