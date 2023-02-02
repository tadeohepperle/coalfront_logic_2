import 'package:coalfront_logic_2/src/models/common/rotation_steps.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_state.dart';
import 'package:coalfront_logic_2/src/models/game_state/id_index_structure.dart';
import 'package:coalfront_logic_2/src/models/game_state/map_state.dart';
import 'package:dartz/dartz.dart';

import '../common/ids.dart';
import '../common/int2.dart';
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

  // put buildings in indexStructure and mark as occupied on map (happens in registerBuilding function):

  final IdIndexStructure indexStructureView =
      IdIndexStructure.fromOtherWithoutBuildings(gameState.indexStructure);

  for (final b in nonPlayerBuildingsVisible.followedBy(playerBuildings)) {
    indexStructureView.insert(b);
  }
  return Tuple2(mapStateView, indexStructureView);
}

List<Int2> positionRotationAndRelativePositionsToWorldPositions(
        Int2 position, RotationSteps rotation, List<Int2> relativePositions) =>
    relativePositions.map((e) => e.rotateAround0(rotation) + position).toList();
