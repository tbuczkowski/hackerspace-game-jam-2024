import 'dart:ui';

import 'package:hackerspace_game_jam_2024/game/npc/enemies.dart';
import 'package:hackerspace_game_jam_2024/game/npc/hobo.dart';
import 'package:hackerspace_game_jam_2024/game/terrain/base_terrain.dart';
import 'package:hackerspace_game_jam_2024/game/terrain/gate.dart';
import 'package:hackerspace_game_jam_2024/game/terrain/ground_block.dart';
import 'package:hackerspace_game_jam_2024/game/terrain/platform_block.dart';
import 'package:hackerspace_game_jam_2024/game/terrain/ulica_block.dart';
import 'package:hackerspace_game_jam_2024/game/terrain/wall_block.dart';
import 'package:hackerspace_game_jam_2024/game/terrain/water.dart';
import 'package:hackerspace_game_jam_2024/game/ui/money.dart';

final Map<Color, Type> colorToBlockType = {
  Color(0x01FF0000): PlatformBlock,
  Color(0x01C0C0C0): NPCMovementLimiter,
  Color(0x0100FF00): GroundBlock,
  Color(0x010000FF): KozakEnemy,
  Color(0x01FFFF00): Money,
  Color(0x01FF00FF): WallBlock,
  Color(0x01c08040): FrogshopGate,
  Color(0x010080C0): Hobo,
  Color(0x0100a0c0): WaterBlock,
  Color(0x0100FFFF): UlicaBlock,
};

final Color playerDef = Color(0x01FFFFFF);
final Color transparentDef = Color(0x01000000);
