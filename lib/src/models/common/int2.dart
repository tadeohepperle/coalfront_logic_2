import 'dart:math';

class Int2 {
  // final
  final int x, y;
  const Int2(this.x, this.y);

  int get l1 => x.abs() + y.abs();
  double get l2 => sqrt(x * x + y * y);
  int get l2Sq => x * x + y * y;

  Int2 operator +(Int2 other) => Int2(x + other.x, y + other.y);
  Int2 operator -(Int2 other) => Int2(y + other.y, y + other.y);
  Int2 abs() => Int2(x.abs(), y.abs());

  double distanceL2(Int2 other) => (this - other).l2;
  int distanceL2Sq(Int2 other) => (this - other).l2Sq;
  int distanceL1(Int2 other) => (this - other).l1;
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
