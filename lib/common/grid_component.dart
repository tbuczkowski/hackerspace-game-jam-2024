import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:hackerspace_game_jam_2024/common/grid_body.dart';

abstract class GridTileComponent {
  String get id;
}

class GridSpriteComponent extends SpriteComponent implements GridTileComponent {
  final String id;

  GridSpriteComponent({
    required Vector2 position,
    required Vector2 size,
    required Sprite sprite,
    String? id,
  })  : id = id ?? '${position.x}/${position.y}',
        super(
          position: position,
          size: size,
          sprite: sprite,
        );
}

class GridBodyComponent extends BodyComponent implements GridTileComponent {
  final Vector2 position;
  final Vector2 size;
  final Sprite sprite;
  final String id;
  final GridBody gridBody;

  GridBodyComponent({
    required this.position,
    required this.size,
    required this.sprite,
    GridBody? body,
    String? id,
  })  : id = id ?? '${position.x}/${position.y}',
        gridBody = body ?? BoxBody(size: size, position: position);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      SpriteComponent(
        sprite: sprite,
        size: size,
        anchor: Anchor.topLeft,
      ),
    );
  }

  @override
  Body createBody() => gridBody.build(world, this);
}
