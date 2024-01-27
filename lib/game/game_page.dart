import 'package:flame/game.dart';
import 'package:flutter/material.dart';

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
      child: GameWidget(game: ASDGame()),
    );
  }
}
