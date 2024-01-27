import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:hackerspace_game_jam_2024/game/you_died_page.dart';
import 'package:hackerspace_game_jam_2024/game/frog_shop_page.dart';
import 'game.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Focus(
      onKey: (focus, onKey) => KeyEventResult.handled,
      child: GameWidget(
        game: ASDGame(),
        overlayBuilderMap: {
          'you_died': (BuildContext context, ASDGame game) => YouDiedPage(),
          'frog_shop': (BuildContext context, ASDGame game) => FrogShopPage(game),
        },
      ),
    );
  }
}
