import 'dart:math';
import 'package:collision/src/rectangle.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

class Obb2 {
  final vm.Vector2 center;
  final double width;
  final double height;
  final double rotation;

  Obb2({
    required this.center,
    required this.width,
    required this.height,
    required this.rotation,
  });

  BakedObb bake() {
    final w2 = width / 2;
    final h2 = height / 2;

    final rad = vm.radians(this.rotation);
    final _cos = cos(rad);
    final _sin = sin(rad);

    final cosx = _cos * w2;
    final cosy = _cos * h2;

    final sinx = _sin * w2;
    final siny = _sin * h2;

    final ix = cosx - siny;
    final iy = cosy + sinx;

    final jx = cosx + siny;
    final jy = cosy - sinx;

    final bottomRight = vm.Vector2(ix, iy) + center;
    final topLeft = vm.Vector2(-ix, -iy) + center;

    final bottomLeft = vm.Vector2(-jx, jy) + center;
    final topRight = vm.Vector2(jx, -jy) + center;

    final rotation = this.rotation % 360;

    if (rotation <= 90) {
      return BakedObb._internal(
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight);
    }
    if (rotation <= 180) {
      return BakedObb._internal(
          bottomLeft: bottomRight,
          topLeft: bottomLeft,
          topRight: topLeft,
          bottomRight: topRight);
    }

    if (rotation <= 270) {
      return BakedObb._internal(
          bottomLeft: topRight,
          topLeft: bottomRight,
          topRight: bottomLeft,
          bottomRight: topLeft);
    }

    return BakedObb._internal(
        topLeft: topRight,
        topRight: bottomRight,
        bottomLeft: topLeft,
        bottomRight: bottomLeft);
  }
}

class BakedObb {
  final vm.Vector2 topLeft;
  final vm.Vector2 topRight;
  final vm.Vector2 bottomLeft;
  final vm.Vector2 bottomRight;

  BakedObb._internal({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  Rectangle innerRectancle() {
    final x1 = max(topLeft.x, bottomLeft.x);
    final y1 = max(topLeft.y, topRight.y);
    final x2 = min(topRight.x, bottomRight.x);
    final y2 = min(bottomLeft.y, bottomRight.y);

    return Rectangle.fromLTRB(x1, y1, x2, y2);
  }
}
