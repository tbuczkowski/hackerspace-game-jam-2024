import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hackerspace_game_jam_2024/3d_renderer/object_3d.dart';
import 'package:hackerspace_game_jam_2024/3d_renderer/project.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

final Object3D cube = Object3D(
  vertices: [
    Vector3(0.0 - 0.5, 0.0 - 0.5, 0.0 - 0.5),
    Vector3(0.0 - 0.5, 0.0 - 0.5, 1.0 - 0.5),
    Vector3(0.0 - 0.5, 1.0 - 0.5, 0.0 - 0.5),
    Vector3(0.0 - 0.5, 1.0 - 0.5, 1.0 - 0.5),
    Vector3(1.0 - 0.5, 0.0 - 0.5, 0.0 - 0.5),
    Vector3(1.0 - 0.5, 0.0 - 0.5, 1.0 - 0.5),
    Vector3(1.0 - 0.5, 1.0 - 0.5, 0.0 - 0.5),
    Vector3(1.0 - 0.5, 1.0 - 0.5, 1.0 - 0.5),
  ],
  triangles: [
    (1 - 1, 7 - 1, 5 - 1),
    (1 - 1, 3 - 1, 7 - 1),
    (1 - 1, 4 - 1, 3 - 1),
    (1 - 1, 2 - 1, 4 - 1),
    (3 - 1, 8 - 1, 7 - 1),
    (3 - 1, 4 - 1, 8 - 1),
    (5 - 1, 7 - 1, 8 - 1),
    (5 - 1, 8 - 1, 6 - 1),
    (1 - 1, 5 - 1, 6 - 1),
    (1 - 1, 6 - 1, 2 - 1),
    (2 - 1, 6 - 1, 8 - 1),
    (2 - 1, 8 - 1, 4 - 1),
  ],
);

class ThreeDRendererPage extends StatefulWidget {
  const ThreeDRendererPage({super.key});

  @override
  State<ThreeDRendererPage> createState() => _ThreeDRendererPageState();
}

class _ThreeDRendererPageState extends State<ThreeDRendererPage> {
  double xRotation = 0;
  double yRotation = 0;
  double zRotation = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            SizedBox.expand(
              child: GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  setState(() {
                    xRotation += details.delta.dy * 0.001;
                    zRotation += details.delta.dx * 0.001;
                  });
                },
                child: View3D(
                  object: cube,
                  xRotation: xRotation,
                  yRotation: yRotation,
                  zRotation: zRotation,
                ),
              ),
            ),
            // Column(
            //   children: [
            //     Slider(
            //       value: xRotation,
            //       onChanged: (double value) {
            //         setState(() {
            //           xRotation = value;
            //         });
            //       },
            //     ),
            //     Slider(
            //       value: yRotation,
            //       onChanged: (double value) {
            //         setState(() {
            //           yRotation = value;
            //         });
            //       },
            //     ),
            //     Slider(
            //       value: zRotation,
            //       onChanged: (double value) {
            //         setState(() {
            //           zRotation = value;
            //         });
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
      );
}

class View3D extends StatelessWidget {
  final Object3D object;
  final double xRotation;
  final double yRotation;
  final double zRotation;

  const View3D({
    required this.object,
    required this.xRotation,
    required this.yRotation,
    required this.zRotation,
    super.key,
  });

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _View3DPainter(
          object,
          xRotation: xRotation,
          yRotation: yRotation,
          zRotation: zRotation,
        ),
      );
}

class _View3DPainter extends CustomPainter {
  final Object3D object;
  final double xRotation;
  final double yRotation;
  final double zRotation;

  static const List<Color> _palette = [...Colors.primaries];
  static final Vector3 cameraPosition = Vector3(0, -2.5, 0);
  static final Vector3 cameraDirection = Vector3(0, 0, 0);

  _View3DPainter(
    this.object, {
    required this.xRotation,
    required this.yRotation,
    required this.zRotation,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final double aspectRatio = size.width / size.height;
    final List<Vector3> transformedVertices = cube.transformedVertices(
      Matrix4.identity()
        ..rotate(Vector3(1, 0, 0), xRotation * math.pi * 2)
        ..rotate(Vector3(0, 1, 0), yRotation * math.pi * 2)
        ..rotate(Vector3(0, 0, 1), zRotation * math.pi * 2),
    );
    final List<Vector3> cameraProjectedVertices =
        transformedVertices.map((Vector3 v) => project(v, cameraPosition, cameraDirection, aspectRatio)).toList();
    final List<(int, (int, int, int))> zSortedTriangles = cube.triangles
        .where(((int, int, int) triangle) {
          final (Vector3 v1, Vector3 v2, Vector3 v3) = (
            transformedVertices[triangle.$1],
            transformedVertices[triangle.$2],
            transformedVertices[triangle.$3],
          );
          final Vector3 normal = (v2 - v1).cross(v3 - v1).normalized();
          final double alignment = ((v1 - cameraPosition).normalized()).dot(normal);
          return alignment.isNegative;
          // return triangle;
        })
        .indexed
        .toList()
      ..sort(((int, (int, int, int)) a, (int, (int, int, int)) b) => ((cameraProjectedVertices[b.$2.$1].z +
                  cameraProjectedVertices[b.$2.$2].z +
                  cameraProjectedVertices[b.$2.$3].z) /
              3)
          .compareTo((cameraProjectedVertices[a.$2.$1].z +
                  cameraProjectedVertices[a.$2.$2].z +
                  cameraProjectedVertices[a.$2.$3].z) /
              3));
    final List<Offset> screenSpaceVertices = cameraProjectedVertices.map((Vector3 v) {
      // Remaps coordinates from [-1, 1] to the [0, viewport].
      return Offset((1.0 + v.x) * size.width / 2, (1.0 - v.y) * size.height / 2);
    }).toList();
    final List<Offset> mesh = zSortedTriangles
        .expand(((int, (int, int, int)) triangle) => [
              screenSpaceVertices[triangle.$2.$1],
              screenSpaceVertices[triangle.$2.$2],
              screenSpaceVertices[triangle.$2.$3],
            ])
        .toList();
    final List<Color> colors = zSortedTriangles.expand(((int i, (int, int, int) triangle) obj) {
      final int index = cube.triangles.indexOf(obj.$2);
      return [
        _palette[index % _palette.length].withOpacity(0.5),
        _palette[index % _palette.length].withOpacity(0.5),
        _palette[index % _palette.length].withOpacity(0.5),
      ];
    }).toList();
    final Vertices vertices = Vertices(VertexMode.triangles, mesh, colors: colors);
    canvas.drawVertices(vertices, BlendMode.srcOver, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
