import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:hackerspace_game_jam_2024/audio/sounds.dart';
import 'package:hackerspace_game_jam_2024/game/game.dart';
import 'package:hackerspace_game_jam_2024/game/level/level_config.dart';
import 'package:hackerspace_game_jam_2024/game/player/player.dart';
import 'package:hackerspace_game_jam_2024/game/ui/speech_component.dart';

class Hobo extends SpriteComponent with CollisionCallbacks, HasGameReference<ASDGame> {
  final Vector2 gridPosition;
  final Vector2 velocity = Vector2.zero();

  final Component _speech;
  bool _isSpeaking = false;

  static const List<String> defaultSpeeches = [
    'Pssst... Kierowniku...',
    'Wnoszę wniosek formalny o poratowanie szlugiem',
    'Królu złoty...',
    'Szefie... jest sprawa...',
  ];

  static Random rand = Random.secure();

  static String randomSpeech() => defaultSpeeches[rand.nextInt(defaultSpeeches.length)];

  Hobo({
    required this.gridPosition,
    String? speechText,
  })  : _speech = SpeechComponent(speechText ?? randomSpeech(), Vector2(-32, -96)),
        super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  void onLoad() {
    var image = game.images.fromCache('blahblahblahmus.png');
    sprite = Sprite(image);

    position = Vector2(
      (gridPosition.x * size.x),
      game.size.y - (gridPosition.y * size.y),
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
    // add(
    //   MoveEffect.by(
    //     Vector2(-2 * size.x, 0),
    //     EffectController(
    //       duration: 3,
    //       alternate: true,
    //       infinite: true,
    //     ),
    //   ),
    // );
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;
    // position += velocity * dt;
    // if (position.x < -size.x) removeFromParent();

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && !_isSpeaking) {
      add(_speech);
      _isSpeaking = true;
      game.audioController.playSfx(SfxType.blah);
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Player) {
      _speech.removeFromParent();
      _isSpeaking = false;
    }

    super.onCollisionEnd(other);
  }
}
