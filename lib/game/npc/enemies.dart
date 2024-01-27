import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';

class WaterEnemy extends SpriteAnimationComponent with HasGameReference<ASDGame> {
  final Vector2 gridPosition;

  final Vector2 velocity = Vector2.zero();

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
    super.update(dt);
  }

  void kill() {
    final Component hitbox = children.firstWhere((element) => element is RectangleHitbox);
    remove(hitbox);
    add(ScaleEffect.by(
      Vector2(1.7, 0.12),
      EffectController(
        duration: 0.07,
      ),
    ));
  }
}
