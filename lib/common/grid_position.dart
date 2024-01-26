import 'package:equatable/equatable.dart';
import 'package:flame/components.dart';

class GridPosition extends Equatable {
  final int x;
  final int y;

  const GridPosition(this.x, this.y);

  static const GridPosition zero = GridPosition(0, 0);

  Vector2 toScreenPosition(double tileSize) => Vector2(x * tileSize, y * tileSize);

  GridPosition clone() => GridPosition(x, y);

  @override
  List<Object?> get props => [x, y];

  @override
  String toString() => '$x/$y';
}