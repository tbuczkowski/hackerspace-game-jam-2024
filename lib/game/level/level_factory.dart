import 'package:flame/components.dart' hide Block;
import 'package:flutter/services.dart';
import 'package:hackerspace_game_jam_2024/game/block.dart';
import 'package:hackerspace_game_jam_2024/game/level/level_config.dart';
import 'package:hackerspace_game_jam_2024/game/level/level_factory_consts.dart';
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

        if (c == playerDef) {
          playerPosition =
              Vector2(x.toDouble(), (levelBitmap.height - y - 1).toDouble());
          continue;
        }

        Type? blockType = factoryConfig.tileTypes[c];

        if (blockType == null) {
          print("Definition for color $c does not exist!");
          continue;
        }

        blocks.add(Block(
            Vector2(x.toDouble(), (levelBitmap.height - y - 1).toDouble()),
            blockType));
      }
    }

    if (playerPosition == null) {
      print("player position not found, setting default!");
      playerPosition = Vector2(1, 1);
    }

    return Level(blocks: blocks, startingPosition: playerPosition);
  }

  Color _getPixelColor(img.Pixel p) =>
      Color.fromRGBO(p.r.toInt(), p.g.toInt(), p.b.toInt(), p.a.toDouble());

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

  Level({required this.blocks, required this.startingPosition});
}
