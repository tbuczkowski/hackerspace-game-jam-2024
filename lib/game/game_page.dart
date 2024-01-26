import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final FlameGame _game = FlameGame();

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: _game);
  }
}
