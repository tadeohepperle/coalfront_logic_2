enum TileType {
  unknown,
  grass,
  forest,
  water,
  sand,
  mountain,
  outOfMap;

  @pragma("vm:prefer-inline")
  factory TileType.fromByte(int b) => TileType.values[b];
  @pragma("vm:prefer-inline")
  int toByte() => index;
}
