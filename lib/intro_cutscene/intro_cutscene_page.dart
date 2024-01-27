import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackerspace_game_jam_2024/audio/audio_controller.dart';
import 'package:hackerspace_game_jam_2024/style/my_button.dart';
import 'package:provider/provider.dart';

class IntroCutscenePage extends StatefulWidget {
  const IntroCutscenePage({super.key});

  @override
  State<IntroCutscenePage> createState() => _IntroCutscenePageState();
}

class _IntroCutscenePageState extends State<IntroCutscenePage> {
  final List scenes = [
    AssetImage('assets/images/cutscenes/intro_3.png'),
    AssetImage('assets/images/cutscenes/intro_4.png'),
    AssetImage('assets/images/cutscenes/intro_5.png'),
    AssetImage('assets/images/cutscenes/intro_6.png'),
  ];

  int currentScene = 0;

  late Timer timer;

  @override
  void initState() {
    final song = AssetSource('music/intro.mp3');
    context.read<AudioController>().musicPlayer.play(song).then((_) {
      context.read<AudioController>().musicPlayer.getDuration().then((value) {
        timer = Timer.periodic(Duration(milliseconds: (value!.inMilliseconds / scenes.length).round()), (timer) {
          if (currentScene < scenes.length - 1) {
            setState(() {
              currentScene++;
            });
          } else {
            timer.cancel();
            GoRouter.of(context).go('/game_page');
          }
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          Positioned(
              bottom: 32,
              right: 32,
              child: MyButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Skip'),
                ),
                onPressed: () {
                  timer.cancel();
                  GoRouter.of(context).go('/game_page');
                },
              )),
          ...scenes.reversed.map((s) {
            final index = scenes.indexOf(s);
            return Padding(
              padding: const EdgeInsets.all(64.0),
              child: Center(
                child: AnimatedOpacity(
                    duration: Duration(milliseconds: 1000),
                    opacity: currentScene > index ? 0 : 1,
                    child: Image(image: s)),
              ),
            );
          }),
        ],
      ),
    );
  }
}
