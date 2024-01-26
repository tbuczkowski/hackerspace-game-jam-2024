import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';

class PlatformBlock extends SpriteComponent with HasGameReference<ASDGame> {
  final Vector2 gridPosition;
  final Vector2 velocity = Vector2.zero();

  PlatformBlock({
    required this.gridPosition,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  void onLoad() {
    final platformImage = game.images.fromCache('block.png');
    sprite = Sprite(platformImage);
    position = Vector2(
      (gridPosition.x * size.x),
      game.size.y - (gridPosition.y * size.y),
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }
}
