import 'package:vector_math/vector_math_64.dart';

class Object3D {
  final List<Vector3> vertices;
  final List<(int, int, int)> triangles;

  Object3D({
    required this.vertices,
    required this.triangles,
  });

  List<Vector3> transformedVertices(Matrix4 transform) => vertices.map((Vector3 v) {
        final Vector4 v4 = Vector4(v.x, v.y, v.z, 1.0)..applyMatrix4(transform);
        return Vector3(v4.x, v4.y, v4.z);
      }).toList();
}
