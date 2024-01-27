// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackerspace_game_jam_2024/game/game_state.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../settings/settings.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();

  static const _gap = SizedBox(height: 10);
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // context.read<AudioController>().playSfx(SfxType.bonk);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.red,
              child: Image(
                image: AssetImage('assets/images/splash.png'),
                fit: BoxFit.fill,
              )),
          ResponsiveScreen(
            squarishMainArea: SizedBox(),
            rectangularMenuArea: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(
                  onPressed: () {
                    GameState.reset();
                    GoRouter.of(context).go('/intro');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: const Text('Play'),
                  ),
                ),
                MainMenuScreen._gap,
                MainMenuScreen._gap,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
