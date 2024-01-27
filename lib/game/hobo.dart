import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';
import 'package:hackerspace_game_jam_2024/game/player/player.dart';
import 'package:hackerspace_game_jam_2024/game/speech_component.dart';

class Hobo extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameReference<ASDGame> {
  final Vector2 gridPosition;
  final Vector2 velocity = Vector2.zero();

  final SpeechComponent _speech = SpeechComponent(
    'Pssst... Kierowniku...',
    Vector2(-32, -96),
  );
  bool _isSpeaking = false;

  Hobo({
    required this.gridPosition,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('hobo.png'),
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
    add(
      MoveEffect.by(
        Vector2(-2 * size.x, 0),
        EffectController(
          duration: 3,
          alternate: true,
          infinite: true,
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;
    // position += velocity * dt;
    // if (position.x < -size.x) removeFromParent();

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && !_isSpeaking) {
      add(_speech);
      _isSpeaking = true;
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Player) {
      _speech.removeFromParent();
      _isSpeaking = false;
    }

    super.onCollisionEnd(other);
  }
}
