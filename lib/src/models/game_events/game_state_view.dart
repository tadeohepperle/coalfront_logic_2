import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_events/library_state_view.dart';
import 'package:coalfront_logic_2/src/models/game_events/player_states_view.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_state.dart';
import 'package:coalfront_logic_2/src/models/game_state/i_resources_index.dart';
import 'package:coalfront_logic_2/src/models/game_state/id_index_structure.dart';
import 'package:coalfront_logic_2/src/models/game_state/indexable_resource.dart';
import 'package:coalfront_logic_2/src/models/game_state/session_state.dart';

import '../game_state/functions/functions.dart';
import '../game_state/ingame/building.dart';
import '../game_state/map_state.dart';
import 'game_event.dart';
import 'game_phase_view.dart';
import 'construct_map_state_and_index_view.dart';

class GameStateView extends GameEvent {
  UserId userId;
  GameId gameId;
  GamePhaseView gamePhase;
  MapState mapState;
  IdIndexStructure indexStructure;
  SessionState sessionState;
  PlayerStatesView playerStates;
  LibraryStateView libraryState;
  GameStateView(
      {required this.userId,
      required this.gameId,
      required this.gamePhase,
      required this.mapState,
      required this.sessionState,
      required this.playerStates,
      required this.libraryState,
      required this.indexStructure});

  /// maps gamestate to subjective perception (eg. masks all areas that are not lit by buildings...)
  factory GameStateView.fromState(GameState gameState, UserId user) {
    final mapStateAndIndexStructure =
        constructMapStateAndIndexView(gameState, user);

    GamePhaseView gamePhase =
        GamePhaseView.fromGamePhase(gameState.gamePhase, user);

    PlayerStatesView playerStates =
        PlayerStatesView.fromPlayerStates(gameState.playerStates, user);

    LibraryStateView libraryState =
        LibraryStateView.fromLibraryState(gameState.libraryState);

    return GameStateView(
      userId: user,
      gameId: gameState.gameId,
      gamePhase: gamePhase,
      mapState: mapStateAndIndexStructure.value1,
      indexStructure: mapStateAndIndexStructure.value2,
      sessionState: gameState.sessionState,
      playerStates: playerStates,
      libraryState: libraryState,
    );
  }

  void registerBuilding(Building building) {
    if (indexStructure.tryResolve<Building, BuildingId>(building.id) != null) {
      throw Exception("Already building registered under id ${building.id}");
    }
    indexStructure.insert(building);
    mapState.setOccuppied(building.positions, building.id);
    // recalculate player netProduction not necessary, because
    final owner = building.buildingType.owner;
    if (owner != null && owner == userId) {
      final netProduction = netProductionOfBuilding(building, indexStructure);
      playerStates.self.netProduction += netProduction;
    }
  }

  void deregisterBuilding(Building building) {
    if (indexStructure.tryResolve<Building, BuildingId>(building.id) == null) {
      throw Exception("Building not registered under id ${building.id}");
    }
    indexStructure.remove<Building, BuildingId>(building.id);
    mapState.setUnoccupied(building.positions);
    // recalculate player netProduction if necessary
    final owner = building.buildingType.owner;
    if (owner != null && owner == userId) {
      final netProduction = netProductionOfBuilding(building, indexStructure);
      playerStates.self.netProduction -= netProduction;
    }
  }
}

/// for now the same
typedef SessionStateView = SessionState;
