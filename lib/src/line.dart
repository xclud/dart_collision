import 'dart:math';

import 'package:vector_math/vector_math_64.dart' as vm;

class Line {
  final vm.Vector2 a;
  final vm.Vector2 b;

  const Line(this.a, this.b);

  vm.Vector2 project(vm.Vector2 p) {
    final lineDir = (b - a).normalized();
    var v = p - a;
    var d = v.dot(lineDir);
    return a + (lineDir * d);
  }

  double distanceToPoint(vm.Vector2 p) {
    final d = (b.x - a.x) * (p.y - a.y) - (b.y - a.y) * (p.x - a.x);

    return d.sign * sqrt(d.abs());
  }

  double? slope() {
    final x1 = a.x;
    final y1 = a.y;
    final x2 = b.x;
    final y2 = b.y;

    if (x1 == x2) return null;
    return (y1 - y2) / (x1 - x2);
  }

  vm.Vector2? intersect(Line other) {
    final s1 = a, e1 = b, s2 = other.a, e2 = other.b;

    final a1 = e1.y - s1.y;
    final b1 = s1.x - e1.x;
    final c1 = a1 * s1.x + b1 * s1.y;

    final a2 = e2.y - s2.y;
    final b2 = s2.x - e2.x;
    final c2 = a2 * s2.x + b2 * s2.y;

    final delta = a1 * b2 - a2 * b1;
    //If lines are parallel, the result will be (NaN, NaN).
    return delta == 0
        ? null
        : new vm.Vector2(
            (b2 * c1 - b1 * c2) / delta, (a1 * c2 - a2 * c1) / delta);
  }

  @override
  String toString() {
    return '$a $b';
  }
}
