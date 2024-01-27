import 'package:hackerspace_game_jam_2024/game/terrain/base_terrain.dart';

class GroundBlock extends BaseTerrain {
  GroundBlock({required super.gridPosition});

  @override
  String get path => 'ground.png';
}
