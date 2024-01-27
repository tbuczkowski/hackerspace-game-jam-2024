// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:hackerspace_game_jam_2024/3d_renderer/3d_renderer_page.dart';
import 'package:hackerspace_game_jam_2024/game/game_page.dart';
import 'package:hackerspace_game_jam_2024/game/level/levels.dart';
import 'package:hackerspace_game_jam_2024/main_menu/main_menu_screen.dart';
import 'package:hackerspace_game_jam_2024/raymarching/raymarching2d_page.dart';

import 'settings/settings_screen.dart';

/// The router describes the game's navigational hierarchy, from the main
/// screen through settings screens all the way to each individual level.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(key: Key('main menu')),
      routes: [
        GoRoute(
            path: 'game_page',
            builder: (context, state) => GamePage(
                  key: const Key('game_page'),
                )),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsScreen(key: Key('settings')),
        ),
        GoRoute(
          path: '3d_renderer',
          builder: (context, state) => const ThreeDRendererPage(key: Key('3d_renderer')),
        ),
        GoRoute(
          path: 'raymarching',
          builder: (context, state) => const Raymarching2DPage(key: Key('3d_renderer')),
        ),
      ],
    ),
  ],
);
