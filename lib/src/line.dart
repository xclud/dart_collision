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

  vm.Vector2? intersectAsSegments(Line other) {
    Line line1 = this;
    final p = line1.a;
    final p2 = line1.b;

    final q = other.a;
    final q2 = other.b;

    var r = p2 - p;
    var s = q2 - q;
    var rxs = r.cross(s);
    var qpxr = (q - p).cross(r);

    // If r x s = 0 and (q - p) x r = 0, then the two lines are collinear.
    if (_isZero(rxs) && _isZero(qpxr)) {
      // // 1. If either  0 <= (q - p) * r <= r * r or 0 <= (p - q) * s <= * s
      // // then the two lines are overlapping,
      // if (considerCollinearOverlapAsIntersect) if ((0 <= (q - p).dot(r) &&
      //         (q - p).dot(r) <= r.dot(r)) ||
      //     (0 <= (p - q).dot(s) && (p - q).dot(s) <= s.dot(s))) return true;

      // 2. If neither 0 <= (q - p) * r = r * r nor 0 <= (p - q) * s <= s * s
      // then the two lines are collinear but disjoint.
      // No need to implement this expression, as it follows from the expression above.
      return null;
    }

    // 3. If r x s = 0 and (q - p) x r != 0, then the two lines are parallel and non-intersecting.
    if (_isZero(rxs) && !_isZero(qpxr)) return null;

    // t = (q - p) x s / (r x s)
    var t = (q - p).cross(s) / rxs;

    // u = (q - p) x r / (r x s)

    var u = (q - p).cross(r) / rxs;

    // 4. If r x s != 0 and 0 <= t <= 1 and 0 <= u <= 1
    // the two line segments meet at the point p + t r = q + u s.
    if (!_isZero(rxs) && (0 <= t && t <= 1) && (0 <= u && u <= 1)) {
      // We can calculate the intersection point using either t or u.
      // An intersection was found.
      return p + (r * t);
    }

    // 5. Otherwise, the two line segments are not parallel but do not intersect.
    return null;
  }

  @override
  String toString() {
    return '$a $b';
  }
}

const double _epsilon = 1e-10;

bool _isZero(double d) {
  return d.abs() < _epsilon;
}
