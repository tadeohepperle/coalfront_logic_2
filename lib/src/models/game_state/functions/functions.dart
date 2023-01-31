import '../../common/int2.dart';

List<List<Int2>> generatePlayerBasePositions(int numPlayers, Int2 mapSize) {
  List<Vec2> points(int numPlayers) {
    switch (numPlayers) {
      case 1:
        return [Vec2(0.5, 0.5)];
      case 2:
        return [Vec2(0.33, 0.33), Vec2(0.66, 0.66)];
      case 3:
        return [Vec2(0.238, 0.69), Vec2(0.761, 0.693), Vec2(0.5, 0.24)];
      case 4:
        return [
          Vec2(0.33, 0.33),
          Vec2(0.66, 0.66),
          Vec2(0.66, 0.33),
          Vec2(0.33, 0.66)
        ];
      case 5:
        return [
          Vec2(0.500, 0.222),
          Vec2(0.778, 0.424),
          Vec2(0.672, 0.751),
          Vec2(0.328, 0.751),
          Vec2(0.222, 0.424)
        ];
    }
    throw Exception("numPlayers must be between 1 and 5!");
  }

  return points(numPlayers).map(
    (e) {
      Int2 cornerPoint1 =
          Int2((mapSize.x * e.x).toInt(), (mapSize.y * e.y).toInt());
      final bp = <Int2>[
        cornerPoint1,
        cornerPoint1 + Int2(1, 0),
        cornerPoint1 + Int2(0, 1),
        cornerPoint1 + Int2(1, 1),
      ];
      return bp;
    },
  ).toList();
}
