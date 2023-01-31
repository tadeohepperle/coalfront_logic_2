import 'package:coalfront_logic_2/src/models/common/game_creation_config.dart';
import 'package:coalfront_logic_2/src/models/game_state/player_state.dart';
import 'package:coalfront_logic_2/src/models/game_state/session_state.dart';

import '../common/ids.dart';
import 'game_phase.dart';
import 'library_state.dart';
import 'map_state.dart';

/// todo: how is the library read in???

class GameState {
  GameState.initialFromConfig(GameCreationConfig config)
      : gamePhase = BeginningPhase(),
        gameId = config.gameId,
        mapState = MapState.initialFromConfig(config),
        sessionState = SessionState(
            owner: config.owner, playersJoined: [], players: config.players),
        playerStates = PlayerStates.initialFromConfig(config),
        libraryState = LibraryState.testDecks();

  GameId gameId;
  GamePhase gamePhase;
  MapState mapState;
  SessionState sessionState;
  PlayerStates playerStates;
  LibraryState libraryState;
}

/// wrapper around GameState but only allows reads and no writes
/// todo
/// class GameStateUnmodifyable {}

/// workaround:
typedef GameStateUnmodifyable = GameState;
