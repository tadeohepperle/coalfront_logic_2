import 'package:coalfront_logic_2/src/models/game_state/game_state.dart';
import 'package:coalfront_logic_2/src/models/game_state/id_index_structure.dart';
import 'package:coalfront_logic_2/src/models/game_state/map_state.dart';
import 'package:dartz/dartz.dart';

import '../common/ids.dart';
import '../game_state/ingame/building.dart';

/// for now, no private view type needed, because MapStateView and MapState have the same fields.
typedef MapStateView = MapState;

/// dart3 use tuple instead
Tuple2<MapStateView, IdIndexStructure> constructMapStateAndIndexView(
    GameState gameState, UserId user) {
  // determine where the players buildings are,
  final mapState = gameState.mapState;
  final indexStructure = gameState.indexStructure;
  final playerBuildings =
      indexStructure.buildings.where((b) => b.buildingType.owner == user);
  final mapStateView = MapState.unknown(mapState.mapSize);

  for (final b in playerBuildings) {
    for (final pos in b.positions) {
      for (final tilePos
          in pos.distanceNeighborhood(b.buildingType.viewRange)) {
        mapStateView.setByteAt(tilePos, mapState.byteAt(tilePos));
      }
    }
  }

  final nonPlayerBuildings =
      indexStructure.buildings.where((b) => b.buildingType.owner != user);
  final nonPlayerBuildingsVisible = <Building>[];
  for (final b in nonPlayerBuildings) {
    for (final pos in b.positions) {
      if (mapStateView.byteAt(pos) != 0) {
        nonPlayerBuildingsVisible.add(b);
      }
    }
  }

  final visibleBuildings =
      nonPlayerBuildingsVisible.followedBy(playerBuildings);

  final IdIndexStructure indexStructureView =
      indexStructure.copyWithBuildings(visibleBuildings);

  return Tuple2(mapStateView, indexStructureView);
}
