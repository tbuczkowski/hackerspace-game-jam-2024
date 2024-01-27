import 'package:hackerspace_game_jam_2024/game/block.dart';
import 'package:hackerspace_game_jam_2024/game/enemies.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';
import 'package:hackerspace_game_jam_2024/game/ground_block.dart';
import 'package:hackerspace_game_jam_2024/game/level/level_factory.dart';
import 'package:hackerspace_game_jam_2024/game/platform_block.dart';
import 'package:hackerspace_game_jam_2024/game/star.dart';

typedef _PaintBlock = Function(ASDGame, Block);

class LevelPainter {
  final Map<Type, _PaintBlock> _painters = {
    GroundBlock: (gameRef, block) => gameRef.world.add(GroundBlock(
          gridPosition: block.gridPosition,
        )),
    PlatformBlock: (gameRef, block) => gameRef.world.add(PlatformBlock(
          gridPosition: block.gridPosition,
        )),
    Star: (gameRef, block) => gameRef.world.add(Star(
          gridPosition: block.gridPosition,
        )),
    WaterEnemy: (gameRef, block) => gameRef.world.add(WaterEnemy(
          gridPosition: block.gridPosition,
        )),
  };

  final ASDGame gameRef;

  LevelPainter({required this.gameRef});

  void paintLevel(Level level) {
    for (final block in level.blocks) {
      _PaintBlock? painter = _painters[block.blockType];
      painter?.call(gameRef, block);
    }
  }
}
