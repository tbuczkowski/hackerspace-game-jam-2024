import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';

abstract class BaseTerrain extends SpriteComponent with HasGameReference<ASDGame> {
  final Vector2 gridPosition;
  final Vector2 velocity = Vector2.zero();

  String get path;

  BaseTerrain({
    required this.gridPosition,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  void onLoad() {
    final platformImage = game.images.fromCache(path);
    sprite = Sprite(platformImage);
    position = Vector2(
      (gridPosition.x * size.x),
      game.size.y - (gridPosition.y * size.y),
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }
}

class NPCMovementLimiter extends PositionComponent with HasGameReference<ASDGame> {

  final Vector2 gridPosition;

  NPCMovementLimiter({required this.gridPosition}) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  void onLoad() {
    position = Vector2(
      (gridPosition.x * size.x),
      game.size.y - (gridPosition.y * size.y),
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }
}
