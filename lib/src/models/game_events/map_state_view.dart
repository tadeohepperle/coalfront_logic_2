import 'package:coalfront_logic_2/src/models/game_state/map_state.dart';

import '../common/ids.dart';
import '../game_state/ingame/coalfront_building.dart';

/// for now, no private view type needed, because MapStateView and MapState have the same fields.
typedef MapStateView = MapState;

extension MapStateViewConstruction on MapStateView {
  static MapStateView fromState(MapState mapState, UserId user) {
    // determine where the players buildings are,

    final playerBuildings =
        mapState.buildings.where((b) => b.buildingType.owner == user);
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
        mapState.buildings.where((b) => b.buildingType.owner != user);
    final nonPlayerBuildingsVisible = <CoalfrontBuilding>[];
    for (final b in nonPlayerBuildings) {
      for (final pos in b.positions) {
        if (mapStateView.byteAt(pos) != 0) {
          nonPlayerBuildingsVisible.add(b);
        }
      }
    }
    mapState.buildings = nonPlayerBuildingsVisible;
    mapState.buildings.addAll(playerBuildings);
    return mapStateView;
  }
}
