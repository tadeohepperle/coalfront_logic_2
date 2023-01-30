enum CoalfrontTileType {
  unknown,
  grass,
  forest,
  water,
  sand,
  mountain;

  @pragma("vm:prefer-inline")
  factory CoalfrontTileType.fromByte(int b) => CoalfrontTileType.values[b];
  @pragma("vm:prefer-inline")
  int toByte() => index;
}
