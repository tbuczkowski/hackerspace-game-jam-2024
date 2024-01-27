import 'dart:ui';

import 'package:hackerspace_game_jam_2024/game/enemies.dart';
import 'package:hackerspace_game_jam_2024/game/terrain/ground_block.dart';
import 'package:hackerspace_game_jam_2024/game/terrain/platform_block.dart';
import 'package:hackerspace_game_jam_2024/game/terrain/wall_block.dart';
import 'package:hackerspace_game_jam_2024/game/star.dart';


final Map<Color, Type> colorToBlockType = {
  Color(0x01FF0000): PlatformBlock,
  Color(0x0100FF00): GroundBlock,
  Color(0x010000FF): WaterEnemy,
  Color(0x01FFFF00): Star,
  Color(0x01FF00FF): WallBlock,
};

final Color playerDef = Color(0x01FFFFFF);
final Color transparentDef = Color(0x01000000);