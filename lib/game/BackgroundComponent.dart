import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';

class BackgroundComponent extends ParallaxComponent<ASDGame> {
  Vector2 lastCameraPosition = Vector2.zero();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    var windowSize = game.camera.viewport.size;
    parallax = await game.loadParallax(
      [
        ParallaxImageData('background/1.png'),
        ParallaxImageData('background/2.png'),
        ParallaxImageData('background/3.png'),
        ParallaxImageData('background/4.png'),
        ParallaxImageData('background/5.png')
      ],
      repeat: ImageRepeat.repeat,
      baseVelocity: Vector2(500, 0),
      velocityMultiplierDelta: Vector2(1.5, 0),
      size: Vector2(windowSize.x, windowSize.y),
      alignment: Alignment.center,
    );
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
    final cameraPosition = game.camera.viewfinder.position;
    final delta = dt > threshold ? 1.0 / (dt * framesPerSec) : 1.0;
    final baseVelocity = cameraPosition
      ..sub(lastCameraPosition)
      ..multiply(backgroundVelocity)
      ..multiply(Vector2(delta, delta));
    parallax!.baseVelocity.setFrom(baseVelocity);
    lastCameraPosition.setFrom(game.camera.viewfinder.position);
  }

  static final backgroundVelocity = Vector2(3.0, 0);
  static const framesPerSec = 60.0;
  static const threshold = 0.005;
}