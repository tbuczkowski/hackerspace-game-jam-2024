import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/text.dart';

class SpeechComponent extends TextBoxComponent {
  SpeechComponent(String text, Vector2 position) : super(
    text: text,
    textRenderer: TextPaint(
      style: const TextStyle(
        fontSize: 32,
        color: Color.fromRGBO(10, 10, 10, 1),
      ),
    ),
    boxConfig: TextBoxConfig(timePerChar: 0.05),
    position: position,
    priority: 5,
  );

  final bgPaint = Paint()..color = Color(0xFFFFFFFF);
  final borderPaint = Paint()..color = Color(0xFF000000)..style = PaintingStyle.stroke;

  @override
  void render(Canvas canvas) {
    Rect rect = Rect.fromLTWH(0, 0, width, height);
    canvas.drawRect(rect, bgPaint);
    canvas.drawRect(rect.deflate(4.0), borderPaint);
    super.render(canvas);
  }
}