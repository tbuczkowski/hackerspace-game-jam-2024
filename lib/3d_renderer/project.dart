import 'dart:math' as math;

import 'package:vector_math/vector_math_64.dart';

Vector3 project(Vector3 point, Vector3 cameraPosition, Vector3 cameraDirection, double aspectRatio) {
  final Matrix4 viewMatrix = makeViewMatrix(
    cameraPosition,
    cameraDirection,
    Vector3(0, 0, 1),
  );

  const double near = 1.0;
  const double fov = 60.0;
  const double zoom = 1.0;
  final double top = near * math.tan(radians(fov) / 2.0) / zoom;
  final double bottom = -top;
  final double right = top * aspectRatio;
  final double left = -right;
  const double far = 1000.0;

  final Matrix4 projectionMatrix = makeFrustumMatrix(
    left,
    right,
    bottom,
    top,
    near,
    far,
  );

  final Matrix4 transformationMatrix = projectionMatrix * viewMatrix;

  final Vector4 projectiveCoords = Vector4(point.x, point.y, point.z, 1.0);
  projectiveCoords.applyMatrix4(transformationMatrix);

  final double x = projectiveCoords.x / projectiveCoords.w;
  final double y = projectiveCoords.y / projectiveCoords.w;
  final double z = projectiveCoords.z / projectiveCoords.w;

  return Vector3(x, y, z);
}
