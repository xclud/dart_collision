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

  test('Line Intersection', () {
    final line1 = Line(Vector2(-1, -1), Vector2(1, 1));
    final line2 = Line(Vector2(-1, 1), Vector2(1, -1));

    final intersect = line1.intersect(line2);

    expect(intersect!.x, 0);
    expect(intersect.y, 0);
  });
}
