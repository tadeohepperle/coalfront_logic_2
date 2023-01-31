import 'dart:typed_data';

import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/tile_type.dart';

import '../common/game_creation_config.dart';
import '../common/int2.dart';
import 'ingame/building.dart';

class MapState {
  Int2 mapSize;
  Int8List tiles;
  MapState({
    required this.mapSize,
    required this.tiles,
  });

  factory MapState.unknown(
    Int2 mapSize,
  ) {
    return MapState(
      mapSize: mapSize,
      tiles: Int8List(mapSize.x * mapSize.y),
    );
  }

  @pragma("vm:prefer-inline")
  TileType operator [](Int2 position) => TileType.fromByte(byteAt(position));

  @pragma("vm:prefer-inline")
  void operator []=(Int2 position, TileType value) =>
      setByteAt(position, value.toByte());

  @pragma("vm:prefer-inline")
  int byteAt(Int2 position) => tiles[position.y * mapSize.x + position.x];

  @pragma("vm:prefer-inline")
  void setByteAt(Int2 position, int value) =>
      tiles[position.y * mapSize.x + position.x] = value;

  factory MapState.initialFromConfig(GameCreationConfig config) {
    final mapSize = config.mapSize;
    final tileCount = mapSize.x * mapSize.y;
    final tiles = Int8List(tileCount);
    // generate tiles:
    // todo
    for (var i = 0; i < tileCount; i++) {
      tiles[i] = ((i + 3) % 13 == 0) || ((i + 3) % 13 == 0)
          ? TileType.mountain.toByte()
          : TileType.grass.toByte();
    }

    return MapState(tiles: tiles, mapSize: mapSize);
  }
}
