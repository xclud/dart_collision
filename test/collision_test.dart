import 'package:test/test.dart';

import 'package:collision/collision.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  test('OBB', () {
    final obb = Obb2(
      center: Vector2(5, 5),
      width: 10,
      height: 10,
      rotation: 45,
    );

    final baked = obb.bake();
    final inner = baked.innerRectancle();

    print(inner);
  });
}
