import 'package:hackerspace_game_jam_2024/game/terrain/base_terrain.dart';

class PlatformBlock extends BaseTerrain {
  PlatformBlock({required super.gridPosition});

  @override
  String get path => 'block.png';
}
