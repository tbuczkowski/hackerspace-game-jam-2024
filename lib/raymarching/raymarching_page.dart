import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class RaymarchingPage extends StatefulWidget {
  const RaymarchingPage({super.key});

  @override
  _RaymarchingPageState createState() => _RaymarchingPageState();
}

class _RaymarchingPageState extends State<RaymarchingPage> with SingleTickerProviderStateMixin {
  late Ticker _ticker;

  Duration _currentTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((Duration elapsed) {
      setState(() {
        _currentTime = elapsed;
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SizedBox.expand(
          child: ShaderBuilder(
            assetKey: 'shaders/raymarching.frag',
            (BuildContext context, FragmentShader shader, _) => CustomPaint(
              painter: RaymarchingPainter(
                shader: shader,
                currentTime: _currentTime,
              ),
            ),
          ),
        ),
      );
}

class RaymarchingPainter extends CustomPainter {
  final FragmentShader shader;
  final Duration currentTime;

  RaymarchingPainter({
    super.repaint,
    required this.shader,
    required this.currentTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, currentTime.inMilliseconds.toDouble());
    final Paint paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(RaymarchingPainter oldDelegate) {
    return true;
  }
}
