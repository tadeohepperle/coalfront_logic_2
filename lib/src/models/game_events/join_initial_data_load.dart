import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_events/library_state_view.dart';
import 'package:coalfront_logic_2/src/models/game_events/player_states_view.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_state.dart';
import 'package:coalfront_logic_2/src/models/game_state/id_index_structure.dart';
import 'package:coalfront_logic_2/src/models/game_state/session_state.dart';

import '../game_state/map_state.dart';
import 'game_event.dart';
import 'game_phase_view.dart';
import 'construct_map_state_and_index_view.dart';

typedef JoinInitialDataLoad = GameStateView;

class GameStateView extends GameEvent {
  GameId gameId;
  GamePhaseView gamePhase;
  MapState mapState;
  IdIndexStructure indexStructure;
  SessionStateView sessionState;
  PlayerStatesView playerStates;
  LibraryStateView libraryState;
  GameStateView(
      {required this.gameId,
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
      gameId: gameState.gameId,
      gamePhase: gamePhase,
      mapState: mapStateAndIndexStructure.value1,
      indexStructure: mapStateAndIndexStructure.value2,
      sessionState: gameState.sessionState,
      playerStates: playerStates,
      libraryState: libraryState,
    );
  }
}

/// for now the same
typedef SessionStateView = SessionState;
