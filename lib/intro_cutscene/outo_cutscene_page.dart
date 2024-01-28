import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackerspace_game_jam_2024/audio/audio_controller.dart';
import 'package:hackerspace_game_jam_2024/style/my_button.dart';
import 'package:provider/provider.dart';

class OutroCutscenePage extends StatefulWidget {
  const OutroCutscenePage({super.key});

  @override
  State<OutroCutscenePage> createState() => _OutroCutscenePageState();
}

class _OutroCutscenePageState extends State<OutroCutscenePage> {
  final List scenes = [
    AssetImage('assets/images/cutscenes/outro_1.png'),
    AssetImage('assets/images/cutscenes/outro_2.png'),
    AssetImage('assets/images/cutscenes/outro_3.png'),
    AssetImage('assets/images/cutscenes/outro_4.png'),
    AssetImage('assets/images/cutscenes/outro_5.png'),
    AssetImage('assets/images/cutscenes/theend.png'),
  ];

  int currentScene = 0;

  late Timer timer;

  @override
  void initState() {
    final song = AssetSource('music/ending.mp3');
    context.read<AudioController>().musicPlayer.setReleaseMode(ReleaseMode.stop);
    context.read<AudioController>().musicPlayer.play(song).then((_) {
      context.read<AudioController>().musicPlayer.getDuration().then((value) {
        timer = Timer.periodic(Duration(milliseconds: (value!.inMilliseconds / scenes.length).round()), (timer) {
          if (currentScene < scenes.length - 1) {
            setState(() {
              currentScene++;
            });
          } else {
            timer.cancel();
            GoRouter.of(context).go('/');
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
                  GoRouter.of(context).go('/');
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
