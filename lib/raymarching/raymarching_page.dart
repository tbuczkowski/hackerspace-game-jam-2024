import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class RaymarchingPage extends StatefulWidget {
  const RaymarchingPage({super.key});

  @override
  _RaymarchingPageState createState() => _RaymarchingPageState();
}

class _RaymarchingPageState extends State<RaymarchingPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SizedBox.expand(
          child: ShaderBuilder(
            assetKey: 'shaders/raymarching.frag',
            (BuildContext context, FragmentShader shader, _) => CustomPaint(
              painter: RaymarchingPainter(shader: shader),
            ),
          ),
        ),
      );
}

class RaymarchingPainter extends CustomPainter {
  final FragmentShader shader;

  RaymarchingPainter({super.repaint, required this.shader});

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    final Paint paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(RaymarchingPainter oldDelegate) {
    return true;
  }
}
