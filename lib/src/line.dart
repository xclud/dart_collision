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
    final x11 = a.x;
    final y11 = a.y;
    final x12 = b.x;
    final y12 = b.y;

    final x21 = other.a.x;
    final y21 = other.a.y;
    final x22 = other.b.x;
    final y22 = other.b.y;

    if (x11 == x21 && y11 == y21) return vm.Vector2(x11, y11);
    if (x12 == x22 && y12 == y22) return vm.Vector2(x12, y22);

    final slope1 = this.slope();
    final slope2 = other.slope();
    if (slope1 == slope2) return null;

    final yint1 = this._yInt();
    final yint2 = other._yInt();

    if (yint1 == yint2) return yint1 == null ? null : vm.Vector2(0, yint1);

    if (slope1 == null) return vm.Vector2(y21, slope2! * y21 + yint2!);
    if (slope2 == null) return vm.Vector2(y11, slope1 * y11 + yint1!);
    final intx = (slope1 * x11 + yint1! - yint2!) / slope2;

    return vm.Vector2(intx, slope1 * intx + yint1);
  }

  double? _yInt() {
    final x1 = a.x;
    final y1 = a.y;
    final x2 = b.x;
    final y2 = b.y;

    if (x1 == x2) return y1 == 0 ? 0 : null;
    if (y1 == y2) return y1;
    return y1 - this.slope()! * x1;
  }

  // double? _xInt() {
  //   final x1 = a.x;
  //   final y1 = a.y;
  //   final x2 = b.x;
  //   final y2 = b.y;

  //   if (y1 == y2) return x1 == 0 ? 0 : null;
  //   if (x1 == x2) return x1;
  //   final slope = this.slope()!;

  //   return (-1 * slope * x1 - y1) / slope;
  // }

  @override
  String toString() {
    return '$a $b';
  }
}
