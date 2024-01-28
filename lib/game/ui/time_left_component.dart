import 'package:flame/components.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';

class TimeLeftComponent extends TextComponent with HasGameRef<ASDGame> {

  @override
  void update(double dt) {
    var timeLeft = gameRef.timeLeft;
    text = "Time Left: $timeLeft";
    super.update(dt);
  }
}