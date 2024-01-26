import 'package:flame/components.dart';
import 'package:hackerspace_game_jam_2024/game/enemies.dart';
import 'package:hackerspace_game_jam_2024/game/ground_block.dart';
import 'package:hackerspace_game_jam_2024/game/platform_block.dart';
import 'package:hackerspace_game_jam_2024/game/star.dart';

bool isTerrain(Component component) {
  return component is GroundBlock || component is PlatformBlock;
}

class Block {
  // gridPosition position is always segment based X,Y.
  // 0,0 is the bottom left corner.
  // 10,10 is the upper right corner.
  final Vector2 gridPosition;
  final Type blockType;
  Block(this.gridPosition, this.blockType);
}

final segments = [
  segment0,
  // segment1,
  // segment2,
  // segment3,
  // segment4,
];

final segment0 = [
  Block(Vector2(0, 0), GroundBlock),
  Block(Vector2(1, 0), GroundBlock),
  Block(Vector2(2, 0), GroundBlock),
  Block(Vector2(3, 0), GroundBlock),
  Block(Vector2(4, 0), GroundBlock),
  Block(Vector2(5, 0), GroundBlock),
  Block(Vector2(5, 1), WaterEnemy),
  Block(Vector2(5, 3), PlatformBlock),
  Block(Vector2(6, 0), GroundBlock),
  Block(Vector2(6, 3), PlatformBlock),
  Block(Vector2(7, 0), GroundBlock),
  Block(Vector2(7, 3), PlatformBlock),
  Block(Vector2(8, 0), GroundBlock),
  Block(Vector2(8, 3), PlatformBlock),
  Block(Vector2(9, 0), GroundBlock),
  Block(Vector2(10, 0), GroundBlock),
  Block(Vector2(11, 0), GroundBlock),
  Block(Vector2(12, 0), GroundBlock),
  Block(Vector2(13, 0), GroundBlock),
  Block(Vector2(14, 0), GroundBlock),
  Block(Vector2(15, 0), GroundBlock),
  Block(Vector2(15, 1), WaterEnemy),
  Block(Vector2(15, 3), PlatformBlock),
  Block(Vector2(16, 0), GroundBlock),
  Block(Vector2(16, 3), PlatformBlock),
  Block(Vector2(17, 0), GroundBlock),
  Block(Vector2(17, 3), PlatformBlock),
  Block(Vector2(18, 0), GroundBlock),
  Block(Vector2(18, 3), PlatformBlock),
  Block(Vector2(19, 0), GroundBlock),
  Block(Vector2(20, 0), GroundBlock),
  Block(Vector2(21, 0), GroundBlock),
  Block(Vector2(22, 0), GroundBlock),
  Block(Vector2(23, 0), GroundBlock),
  Block(Vector2(24, 0), GroundBlock),
  Block(Vector2(25, 0), GroundBlock),
  Block(Vector2(25, 1), WaterEnemy),
  Block(Vector2(25, 3), PlatformBlock),
  Block(Vector2(26, 0), GroundBlock),
  Block(Vector2(26, 3), PlatformBlock),
  Block(Vector2(26, 4), Star),
  Block(Vector2(27, 0), GroundBlock),
  Block(Vector2(27, 3), PlatformBlock),
  Block(Vector2(28, 0), GroundBlock),
  Block(Vector2(28, 3), PlatformBlock),
  Block(Vector2(29, 0), GroundBlock),
];

final segment1 = [
  Block(Vector2(0, 0), GroundBlock),
  Block(Vector2(1, 0), GroundBlock),
  Block(Vector2(1, 1), PlatformBlock),
  Block(Vector2(1, 2), PlatformBlock),
  Block(Vector2(1, 3), PlatformBlock),
  Block(Vector2(2, 6), PlatformBlock),
  Block(Vector2(3, 6), PlatformBlock),
  Block(Vector2(6, 5), PlatformBlock),
  Block(Vector2(7, 5), PlatformBlock),
  Block(Vector2(7, 7), Star),
  Block(Vector2(8, 0), GroundBlock),
  Block(Vector2(8, 1), PlatformBlock),
  Block(Vector2(8, 5), PlatformBlock),
  Block(Vector2(8, 6), WaterEnemy),
  Block(Vector2(9, 0), GroundBlock),
];

final segment2 = [
  Block(Vector2(0, 0), GroundBlock),
  Block(Vector2(1, 0), GroundBlock),
  Block(Vector2(2, 0), GroundBlock),
  Block(Vector2(3, 0), GroundBlock),
  Block(Vector2(3, 3), PlatformBlock),
  Block(Vector2(4, 0), GroundBlock),
  Block(Vector2(4, 3), PlatformBlock),
  Block(Vector2(5, 0), GroundBlock),
  Block(Vector2(5, 3), PlatformBlock),
  Block(Vector2(5, 4), WaterEnemy),
  Block(Vector2(6, 0), GroundBlock),
  Block(Vector2(6, 3), PlatformBlock),
  Block(Vector2(6, 4), PlatformBlock),
  Block(Vector2(6, 5), PlatformBlock),
  Block(Vector2(6, 7), Star),
  Block(Vector2(7, 0), GroundBlock),
  Block(Vector2(8, 0), GroundBlock),
  Block(Vector2(9, 0), GroundBlock),
];

final segment3 = [
  Block(Vector2(0, 0), GroundBlock),
  Block(Vector2(1, 0), GroundBlock),
  Block(Vector2(1, 1), WaterEnemy),
  Block(Vector2(2, 0), GroundBlock),
  Block(Vector2(2, 1), PlatformBlock),
  Block(Vector2(2, 2), PlatformBlock),
  Block(Vector2(4, 4), PlatformBlock),
  Block(Vector2(6, 6), PlatformBlock),
  Block(Vector2(7, 0), GroundBlock),
  Block(Vector2(7, 1), PlatformBlock),
  Block(Vector2(8, 0), GroundBlock),
  Block(Vector2(8, 8), Star),
  Block(Vector2(9, 0), GroundBlock),
];

final segment4 = [
  Block(Vector2(0, 0), GroundBlock),
  Block(Vector2(1, 0), GroundBlock),
  Block(Vector2(2, 0), GroundBlock),
  Block(Vector2(2, 3), PlatformBlock),
  Block(Vector2(3, 0), GroundBlock),
  Block(Vector2(3, 1), WaterEnemy),
  Block(Vector2(3, 3), PlatformBlock),
  Block(Vector2(4, 0), GroundBlock),
  Block(Vector2(5, 0), GroundBlock),
  Block(Vector2(5, 5), PlatformBlock),
  Block(Vector2(6, 0), GroundBlock),
  Block(Vector2(6, 5), PlatformBlock),
  Block(Vector2(6, 7), Star),
  Block(Vector2(7, 0), GroundBlock),
  Block(Vector2(8, 0), GroundBlock),
  Block(Vector2(8, 3), PlatformBlock),
  Block(Vector2(9, 0), GroundBlock),
  Block(Vector2(9, 1), WaterEnemy),
  Block(Vector2(9, 3), PlatformBlock),
];
