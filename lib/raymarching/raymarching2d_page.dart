import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

final List<({int x, int y})> spheres = [
  (x: 255, y: 0),
  (x: 128, y: 0),
  (x: 0, y: 128),
];

class Raymarching2DPage extends StatefulWidget {
  const Raymarching2DPage({super.key});

  @override
  State<Raymarching2DPage> createState() => _Raymarching2DPageState();
}

class _Raymarching2DPageState extends State<Raymarching2DPage> {
  static const kImageDimension = 256;

  Future<ui.Image> makeImage() {
    final c = Completer<ui.Image>();
    final pixels = Int32List(kImageDimension);
    for (int i = 0; i < pixels.length; i++) {
      pixels[i] = 0x00000000;
    }
    for (int i = 0; i < spheres.length; i++) {
      final sphere = spheres[i];
      pixels[i] = Color.fromARGB(255, sphere.x, sphere.y, 0).value;
    }
    ui.decodeImageFromPixels(
      pixels.buffer.asUint8List(),
      kImageDimension,
      1,
      ui.PixelFormat.rgba8888,
      c.complete,
      allowUpscaling: false,
    );
    return c.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: FutureBuilder<ui.Image>(
          future: makeImage(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ShaderBuilder(
                assetKey: 'shaders/raymarching2d.frag',
                (BuildContext context, FragmentShader shader, _) => CustomPaint(
                  painter: Raymarching2DPainter(
                    shader: shader,
                    encodedSpheres: snapshot.data!,
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class Raymarching2DPainter extends CustomPainter {
  final FragmentShader shader;
  final ui.Image encodedSpheres;

  Raymarching2DPainter({super.repaint, required this.shader, required this.encodedSpheres});

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setImageSampler(0, encodedSpheres);
    final Paint paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(Raymarching2DPainter oldDelegate) {
    return true;
  }
}
