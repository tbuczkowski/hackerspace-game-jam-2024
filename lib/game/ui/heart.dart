import 'package:flame/components.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';

enum HeartState {
  available,
  unavailable,
}

class HeartHealthComponent extends SpriteGroupComponent<HeartState> with HasGameReference<ASDGame> {
  final int heartNumber;

  HeartHealthComponent({
    required this.heartNumber,
    required super.position,
    required super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.priority,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final availableSprite = await game.loadSprite(
      'specek.png',
      srcSize: Vector2.all(500),
    );

    final unavailableSprite = await game.loadSprite(
      'zbita_butelka.png',
      srcSize: Vector2(612, 408),
    );

    sprites = {
      HeartState.available: availableSprite,
      HeartState.unavailable: unavailableSprite,
    };

    current = HeartState.available;
  }

  @override
  void update(double dt) {
    if (game.health < heartNumber) {
      current = HeartState.unavailable;
    } else {
      current = HeartState.available;
    }
    super.update(dt);
  }
}
