import 'dart:async';

import 'package:flame/components.dart';
import 'package:hackerspace_game_jam_2024/common/grid_component.dart';
import 'package:hackerspace_game_jam_2024/common/grid_tile.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';

/// FIXME: check cubit performance for state management
class Grid extends PositionComponent with HasGameRef<ASDGame> {
  final double tileSize;
  final List<List<GridTile>> tiles;
  final bool debugMode = false;

  Vector2 _lastCameraPosition = Vector2.zero();
  bool _buildingTiles = false;
  Set<String> _visibleSet = {};

  Grid({required this.tileSize, this.tiles = const []});

  @override
  Future<void> onLoad() async {
    await Future.wait(tiles.expand((t) => t).map((t) => t.load()));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_buildingTiles && _hasCameraMoved()) {
      scheduleMicrotask(_searchTilesToRender);
    }
  }

  void _searchTilesToRender() {
    _buildingTiles = true;

    final Vector2 gameSize = gameRef.camera.viewport.size;

    int startColumn = (_lastCameraPosition.x / tileSize).floor();
    int startRow = (_lastCameraPosition.y / tileSize).floor();

    startColumn = startColumn < 0 ? 0 : startColumn;
    startRow = startRow < 0 ? 0 : startRow;

    int endColumn = ((_lastCameraPosition.x + gameSize.x) / tileSize).ceil();
    int endRow = ((_lastCameraPosition.y + gameSize.y) / tileSize).ceil();

    if (debugMode) {
      print('camera position: $_lastCameraPosition; game size: $gameSize');
      print('render columns $startColumn to $endColumn');
      print('render rows $startRow to $endRow');
    }

    List<GridTile> visibleTiles = [];

    for (int x = startColumn; x < endColumn; x++) {
      for (int y = startRow; y < endRow; y++) {
        if (!(tiles[x][y] is EmptyGridTile)) {
          visibleTiles.add(tiles[x][y]);
        }
      }
    }

    final List<GridTile> tilesToAdd = visibleTiles.where((element) {
      return !_visibleSet.contains(element.id);
    }).toList();

    _visibleSet = visibleTiles.map((e) => e.id).toSet();

    removeWhere((tile) => !_visibleSet.contains((tile as GridTileComponent).id));
    addAll(tilesToAdd.map((t) => t.buildComponent()));

    _buildingTiles = false;
  }

  bool _hasCameraMoved() {
    final Vector2 cameraPos = gameRef.camera.viewport.position;

    if (cameraPos != _lastCameraPosition) {
      _lastCameraPosition = cameraPos;
      return true;
    }

    return false;
  }
}
