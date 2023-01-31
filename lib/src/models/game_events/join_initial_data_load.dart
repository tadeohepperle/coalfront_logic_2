import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_events/library_state_view.dart';
import 'package:coalfront_logic_2/src/models/game_events/player_states_view.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_state.dart';
import 'package:coalfront_logic_2/src/models/game_state/session_state.dart';

import '../game_state/library_state.dart';
import '../game_state/player_state.dart';
import 'game_phase_view.dart';
import 'map_state_view.dart';

typedef JoinInitialDataLoad = GameStateView;

class GameStateView {
  GameId gameId;
  GamePhaseView gamePhase;
  MapStateView mapState;
  SessionStateView sessionState;
  PlayerStatesView playerStates;
  LibraryStateView libraryState;
  GameStateView({
    required this.gameId,
    required this.gamePhase,
    required this.mapState,
    required this.sessionState,
    required this.playerStates,
    required this.libraryState,
  });

  /// maps gamestate to subjective perception (eg. masks all areas that are not lit by buildings...)
  factory GameStateView.fromState(GameState gameState, UserId user) {
    MapStateView mapState =
        MapStateViewConstruction.fromState(gameState.mapState, user);
    GamePhaseView gamePhase =
        GamePhaseView.fromGamePhase(gameState.gamePhase, user);

    PlayerStatesView playerStates =
        PlayerStatesView.fromPlayerStates(gameState.playerStates, user);

    LibraryStateView libraryState =
        LibraryStateView.fromState(gameState.libraryState);

    return GameStateView(
      gameId: gameState.gameId,
      gamePhase: gamePhase,
      mapState: mapState,
      sessionState: gameState.sessionState,
      playerStates: playerStates,
      libraryState: libraryState,
    );
  }
}

/// for now the same
typedef SessionStateView = SessionState;
