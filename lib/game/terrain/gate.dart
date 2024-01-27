import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';

class FrogshopGate extends SpriteComponent with HasGameReference<ASDGame> {
  final Vector2 gridPosition;

  final Vector2 velocity = Vector2.zero();

  FrogshopGate({
    required this.gridPosition,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  void onLoad() {
    final starImage = game.images.fromCache('gate.png');
    sprite = Sprite(starImage);
    position = Vector2(
      (gridPosition.x * size.x) + (size.x / 2),
      game.size.y - (gridPosition.y * size.y) - (size.y / 2),
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;

    super.update(dt);
  }
}

class FrogshopBackground extends SpriteComponent with HasGameReference<ASDGame> {
  final Vector2 gridPosition;

  final Vector2 velocity = Vector2.zero();

  FrogshopBackground({
    required this.gridPosition,
  }) : super(size: Vector2.all(256), anchor: Anchor.center, priority: 1);

  @override
  void onLoad() {
    final starImage = game.images.fromCache('frogshop.png');
    sprite = Sprite(starImage);
    position = Vector2(
      ((gridPosition.x - 2) * 64) + (size.x / 2),
      game.size.y - ((gridPosition.y - 0.5) * 64) - (size.y / 2),
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;

    super.update(dt);
  }
}
