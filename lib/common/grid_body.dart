import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

abstract class GridBody {

  final Vector2 size;
  final Vector2 position;

  GridBody({ required this.size, required this.position });

  Body build(Forge2DWorld world, Object? userData);
}

class BoxBody extends GridBody {
  BoxBody({ required super.size, required super.position });

  FixtureDef _buildFixtureDefinition(Vector2 size) {
    final PolygonShape shape = PolygonShape();
    final List<Vector2> vertices = [
      Vector2(0, 0),
      Vector2(0, size.y),
      Vector2(size.x, size.y),
      Vector2(size.x, 0),
    ];
    shape.set(vertices);

    return FixtureDef(
      shape,
      density: 1.0,
      friction: 0.3,
    );
  }

  BodyDef _buildBodyDef(Vector2 position, Object? userData) => BodyDef(
        userData: userData, // To be able to determine object in collision
        position: position,
      );

  Body build(Forge2DWorld world, Object? userData) =>
      world.createBody(_buildBodyDef(position, userData))..createFixture(_buildFixtureDefinition(size));
}
