import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';
import 'package:hackerspace_game_jam_2024/game/ui/heart.dart';

import 'time_left_component.dart';

class Hud extends PositionComponent with HasGameReference<ASDGame> {
  Hud({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  });

  late TextComponent _scoreTextComponent;
  late TextComponent _zappScoreTextComponent;

  @override
  Future<void> onLoad() async {
    _scoreTextComponent = TextComponent(
      text: '${game.currentScore}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(10, 10, 10, 1),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x - 60, 20),
    );
    add(_scoreTextComponent);

    final moneySprite = await game.loadSprite('static_money.png');
    add(
      SpriteComponent(
          sprite: moneySprite,
          position: Vector2(game.size.x - 100, 20),
          size: Vector2.all(24),
          anchor: Anchor.center,
          scale: Vector2(1.5, 1.5)),
    );

    for (var i = 1; i <= ASDGame.maxHealth; i++) {
      final positionX = 40 * i;
      await add(
        HeartHealthComponent(
          heartNumber: i,
          position: Vector2(positionX.toDouble(), 32),
          size: Vector2.all(32 * 3.5),
        ),
      );
    }
    await(add(TimeLeftComponent()));

    _zappScoreTextComponent = TextComponent(
      text: '${game.currentFrogPoints}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(10, 10, 10, 1),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x - 160, 20),
    );
    add(_zappScoreTextComponent);

    final zappSprite = await game.loadSprite('zapps.png');
    add(
      SpriteComponent(
          sprite: zappSprite,
          position: Vector2(game.size.x - 200, 20),
          size: Vector2.all(24),
          anchor: Anchor.center,
          scale: Vector2(1.5, 1.5)),
    );
  }

  @override
  void update(double dt) {
    _scoreTextComponent.text = '${game.currentScore}';
    _zappScoreTextComponent.text = "${game.currentFrogPoints}";
  }
}
