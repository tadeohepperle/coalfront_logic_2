import 'dart:typed_data';

import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_state.dart';
import 'package:coalfront_logic_2/src/models/common/user.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/coalfront_tile_type.dart';
import 'package:coalfront_logic_2/src/models/player_actions/i_viewable.dart';
import 'package:dartz/dartz.dart';

import '../common/game_creation_config.dart';
import '../common/int2.dart';
import 'ingame/coalfront_building.dart';

class MapState implements IViewable<MapStateView, Unit> {
  Int2 mapSize;
  Int8List tiles;
  List<CoalfrontBuilding> buildings;
  MapState._({
    required this.mapSize,
    required this.tiles,
    required this.buildings,
  });

  @pragma("vm:prefer-inline")
  CoalfrontTileType operator [](Int2 position) =>
      tileAt(position.x, position.y);

  @pragma("vm:prefer-inline")
  CoalfrontTileType tileAt(int x, int y) =>
      CoalfrontTileType.fromByte(tiles[y * mapSize.x + x]);

  factory MapState.initialFromConfig(GameCreationConfig config) {
    final mapSize = config.mapSize;
    final tileCount = mapSize.x * mapSize.y;
    final tiles = Int8List(tileCount);
    // generate tiles:
    // todo
    for (var i = 0; i < tileCount; i++) {
      tiles[i] = ((i + 3) % 13 == 0) || ((i + 3) % 13 == 0)
          ? CoalfrontTileType.mountain.toByte()
          : CoalfrontTileType.grass.toByte();
    }
    // set initial player buildings:
    final buildings = <CoalfrontBuilding>[];
    final basePositions =
        generatePlayerBasePositions(config.players.length, mapSize);
    for (var i = 0; i < config.players.length; i++) {
      final player = config.players[i];
      final baseBuilding = CoalfrontBuilding(
        buildingId: generateUniqueId(),
        positions: basePositions[i],
        buildingType: CoalfrontBaseBuilding(userId: player.userId),
      );
    }

    return MapState._(buildings: [], tiles: tiles, mapSize: mapSize);
  }

  static List<List<Int2>> generatePlayerBasePositions(
      int numPlayers, Int2 mapSize) {
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

  @override
  MapStateView getView(GameStateUnmodifyable gameState, User user) {
    // TODO: implement getView
    throw UnimplementedError();
  }
}

class MapStateView extends PublicView<Unit> {}
