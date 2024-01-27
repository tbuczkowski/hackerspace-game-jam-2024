import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:hackerspace_game_jam_2024/audio/audio_controller.dart';
import 'package:hackerspace_game_jam_2024/game/you_died_page.dart';
import 'package:provider/provider.dart';

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
        game: ASDGame(context.read<AudioController>()),
        overlayBuilderMap: {
          'you_died': (BuildContext context, ASDGame game) => YouDiedPage(),
        },
      ),
    );
  }
}
