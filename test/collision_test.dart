import 'package:test/test.dart';

import 'package:collision/collision.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  test('OBB Baking', () {
    final obb = Obb2(
      center: Vector2(0, 0),
      width: 10,
      height: 10,
      rotation: 45,
    );

    final baked = obb.bake();

    expect(baked.topLeft.x, 0);
    expect(baked.topLeft.y, -7.0710678118654755);
  });

  test('Line Slope', () {
    final line1 = Line(Vector2(-1, -1), Vector2(1, 1));
    final line2 = Line(Vector2(-1, 1), Vector2(1, -1));

    expect(line1.slope(), 1);
    expect(line2.slope(), -1);
  });

  test('Line Intersection', () {
    final line1 = Line(Vector2(-1, -1), Vector2(1, 1));
    final line2 = Line(Vector2(-1, 1), Vector2(1, -1));

    final intersect = line1.intersect(line2);

    expect(intersect!.x, 0);
    expect(intersect.y, 0);
  });

  test('Line Segment Intersection', () {
    final line1 = Line(Vector2(0, 0), Vector2(5, 5));
    final line2 = Line(Vector2(0, 5), Vector2(5, 0));

    final intersection = line1.intersectAsSegments(line2);

    expect(intersection!.x, 2.5);
    expect(intersection.y, 2.5);
  });
}
