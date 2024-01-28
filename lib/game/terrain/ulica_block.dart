import 'package:flame/components.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';

class UlicaBlock extends SpriteComponent with HasGameReference<ASDGame> {
  final Vector2 gridPosition;

  final Vector2 velocity = Vector2.zero();

  UlicaBlock({
    required this.gridPosition,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  void onLoad() {
    final starImage = game.images.fromCache('street.png');
    sprite = Sprite(starImage);
    position = Vector2(
      (gridPosition.x * size.x) + (size.x / 2),
      game.size.y - (gridPosition.y * size.y) - (size.y / 2),
    );
    // add(RectangleHitbox(collisionType: CollisionType.passive));
  }
}
