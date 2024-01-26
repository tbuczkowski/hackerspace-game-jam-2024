import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:hackerspace_game_jam_2024/common/grid_body.dart';
import 'package:hackerspace_game_jam_2024/common/grid_component.dart';
import 'package:hackerspace_game_jam_2024/common/grid_position.dart';

class GridTile {
  late final Sprite _sprite;

  final double size;
  final String spritePath;
  final GridPosition gridPosition;
  final String id;

  GridTile({
    required this.spritePath,
    required this.size,
    this.gridPosition = GridPosition.zero,
  }) : id = '$gridPosition:${DateTime.now().microsecondsSinceEpoch}';

  factory GridTile.random({
    required List<String> paths,
    GridPosition gridPosition = GridPosition.zero,
    required double size,
  }) {
    final String spritePath = paths.sample(1).single;
    return GridTile(spritePath: spritePath, size: size, gridPosition: gridPosition);
  }

  Future<void> load() async {
    _sprite = await Sprite.load(spritePath);
  }

  Component buildComponent() => GridSpriteComponent(
        sprite: _sprite,
        size: Vector2(size, size),
        position: gridPosition.toScreenPosition(size),
        id: id,
      );
}

class GridBodyTile extends GridTile {
  final GridBody? body;

  GridBodyTile({
    required super.spritePath,
    required super.size,
    super.gridPosition,
    this.body,
  });

  Component buildComponent() => GridBodyComponent(
        sprite: _sprite,
        size: Vector2(size, size),
        position: gridPosition.toScreenPosition(size),
        id: id,
        body: body,
      );
}

class EmptyGridTile extends GridTile {
  EmptyGridTile({
    String? placeholderPath,
    required super.size,
    super.gridPosition,
  }) : super(spritePath: placeholderPath ?? 'dungeon/placeholder.png');
}
