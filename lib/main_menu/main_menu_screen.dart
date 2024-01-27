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
      body: ResponsiveScreen(
        squarishMainArea: Center(
          child: Transform.rotate(
            angle: -0.1,
            child: const Text(
              'Flutter Game Template!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 55,
                height: 1,
              ),
            ),
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MyButton(
              onPressed: () {
                GameState.reset();
                GoRouter.of(context).go('/game_page');
              },
              child: const Text('Play'),
            ),
            MainMenuScreen._gap,
            MyButton(
              onPressed: () {
                GoRouter.of(context).go('/3d_renderer');
              },
              child: const Text('3D Renderer'),
            ),
            MainMenuScreen._gap,
            MyButton(
              onPressed: () {
                GoRouter.of(context).go('/raymarching');
              },
              child: const Text('Raymarching'),
            ),
            MainMenuScreen._gap,
            MyButton(
              onPressed: () => GoRouter.of(context).push('/settings'),
              child: const Text('Settings'),
            ),
            MainMenuScreen._gap,
            const Text('Music by Mr Smith'),
            MainMenuScreen._gap,
          ],
        ),
      ),
    );
  }
}
