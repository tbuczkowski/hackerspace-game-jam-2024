import 'package:collection/collection.dart';
import 'package:flame/components.dart' hide Block;
import 'package:flutter/services.dart';
import 'package:hackerspace_game_jam_2024/game/block.dart';
import 'package:hackerspace_game_jam_2024/game/level/level_config.dart';
import 'package:hackerspace_game_jam_2024/game/level/level_factory_consts.dart';
import 'package:hackerspace_game_jam_2024/game/npc/base_enemy.dart';
import 'package:hackerspace_game_jam_2024/game/npc/enemies.dart';
import 'package:hackerspace_game_jam_2024/game/npc/hobo.dart';
import 'package:hackerspace_game_jam_2024/game/npc/mah_yntelygent_enemy.dart';
import 'package:image/image.dart' as img;

class LevelFactoryConfig {
  final Map<Color, Type> tileTypes;

  LevelFactoryConfig(this.tileTypes);

  factory LevelFactoryConfig.build() => LevelFactoryConfig(colorToBlockType);
}

class LevelFactory {
  final LevelFactoryConfig factoryConfig;

  LevelFactory(this.factoryConfig);

  Future<Level> build(LevelConfig config) async {
    List<Block> blocks = [];
    Vector2? playerPosition;

    img.Image levelBitmap = await _loadLevelBitmap(config);

    for (int x = 0; x < levelBitmap.width; x++) {
      for (int y = 0; y < levelBitmap.height; y++) {
        final Color c = _getPixelColor(levelBitmap.getPixel(x, y));

        if (c == transparentDef) {
          continue;
        }

        final Vector2 currentGridPos = Vector2(x.toDouble(), (levelBitmap.height - y - 1).toDouble());

        if (c == playerDef) {
          playerPosition = currentGridPos;
          continue;
        }

        Type? blockType = factoryConfig.tileTypes[c];

        if (blockType == null) {
          print("Definition for color $c does not exist!");
          continue;
        }

        Object? extras = _getExtras(config, blockType, currentGridPos);
        if (extras != null && extras is EnemyMovementDef && blockType == KozakEnemy) {
          blockType = MahYntelygentEnemy;
        }

        blocks.add(Block(
          currentGridPos,
          blockType,
          extras: _getExtras(config, blockType, currentGridPos),
        ));
      }
    }

    if (playerPosition == null) {
      print("player position not found, setting default!");
      playerPosition = Vector2(1, 1);
    } else {
      print('Starting position is $playerPosition');
    }

    return Level(
      blocks: blocks,
      startingPosition: playerPosition,
      playerMovementType: config.playerMovementType,
    );
  }

  Object? _getExtras(LevelConfig config, Type blockType, Vector2 gridPos) {
    if (blockType == Hobo) {
      return config.speeches.firstWhereOrNull((s) => s.x == gridPos.x && s.y == gridPos.y);
    } else if (blockType == KozakEnemy) {
      return config.enemyMovements
          .firstWhereOrNull((m) => m.y == gridPos.y && m.rightXBoundary > gridPos.x && m.leftXBoundary < gridPos.x);
    }

    return null;
  }

  Color _getPixelColor(img.Pixel p) => Color.fromRGBO(p.r.toInt(), p.g.toInt(), p.b.toInt(), p.a.toDouble());

  Future<img.Image> _loadLevelBitmap(LevelConfig config) async {
    ByteData byteData = await rootBundle.load(config.filename);
    img.Image? image = img.decodeImage(byteData.buffer.asUint8List());

    if (image == null) {
      throw "Aaaaand we're fucked - cannot load level bitmap.";
    }

    return image;
  }
}

class Level {
  final List<Block> blocks;
  final Vector2 startingPosition;
  final PlayerMovementType playerMovementType;

  Level({
    required this.blocks,
    required this.startingPosition,
    required this.playerMovementType,
  });
}
