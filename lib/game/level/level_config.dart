import 'dart:convert';

import 'package:flutter/services.dart';

enum PlayerMovementType { walking, flying }

class LevelConfig {
  final String filename;
  final PlayerMovementType playerMovementType;

  LevelConfig({
    required this.filename,
    this.playerMovementType = PlayerMovementType.walking,
  });

  static Future<LevelConfig> load(String filename) async {
    String json = await rootBundle.loadString(filename);
    Map<String, dynamic> raw = jsonDecode(json);

    return LevelConfig(
      filename: raw['filename'],
      playerMovementType:
          PlayerMovementType.values.byName(raw['playerMovementType']),
    );
  }
}
