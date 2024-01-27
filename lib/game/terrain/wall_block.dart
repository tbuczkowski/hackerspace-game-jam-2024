import 'package:hackerspace_game_jam_2024/game/terrain/base_terrain.dart';

class WallBlock extends BaseTerrain {
  WallBlock({required super.gridPosition});

  @override
  String get path => 'wall.png';
}
