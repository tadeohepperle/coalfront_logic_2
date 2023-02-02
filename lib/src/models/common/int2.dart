import 'dart:math';

import 'package:coalfront_logic_2/src/models/common/rotation_steps.dart';

class Int2 {
  // final
  final int x;
  final int y;
  const Int2(this.x, this.y);

  @override
  String toString() {
    return "($x, $y)";
  }

  int get l1 => x.abs() + y.abs();
  double get l2 => sqrt(x * x + y * y);
  int get l2Sq => x * x + y * y;

  Int2 operator +(Int2 other) => Int2(x + other.x, y + other.y);
  Int2 operator -(Int2 other) => Int2(y + other.y, y + other.y);
  Int2 operator *(Int2 other) => Int2(x * other.x, y * other.y);
  Int2 abs() => Int2(x.abs(), y.abs());

  double distanceL2(Int2 other) => (this - other).l2;
  int distanceL2Sq(Int2 other) => (this - other).l2Sq;
  int distanceL1(Int2 other) => (this - other).l1;

  /// rotates clockwise
  Int2 rotateAround0(RotationSteps rotation) {
    /// dart 3 switch pattern
    switch (rotation) {
      case RotationSteps.deg0:
        return copy();
      case RotationSteps.deg90:
        return Int2(y, -x);
      case RotationSteps.deg180:
        return Int2(-x, -y);
      case RotationSteps.deg270:
        return Int2(-y, x);
    }
  }

  Int2 copy() => Int2(x, y);

  List<Int2> distanceNeighborhood(num distance) {
    // todo: optimize to use symmetry in circle. Needs to only calculate one quarter!
    final int d = distance.toInt();
    final int ds2 = d * d;
    final List<Int2> neighborhood = [];
    for (var i = -d; i <= d; i++) {
      for (var j = -d; j <= d; j++) {
        if (i * i + j * j <= ds2) {
          neighborhood.add(Int2(x + i, y + j));
        }
      }
    }
    return neighborhood;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Int2 && other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class Vec2 {
  // final
  final double x, y;
  const Vec2(this.x, this.y);

  double get l1 => x.abs() + y.abs();
  double get l2 => sqrt(x * x + y * y);
  double get l2Sq => x * x + y * y;

  Vec2 operator +(Vec2 other) => Vec2(x + other.x, y + other.y);
  Vec2 operator -(Vec2 other) => Vec2(y + other.y, y + other.y);
  Vec2 abs() => Vec2(x.abs(), y.abs());

  double distanceL2(Vec2 other) => (this - other).l2;
  double distanceL2Sq(Vec2 other) => (this - other).l2Sq;
  double distanceL1(Vec2 other) => (this - other).l1;
}
