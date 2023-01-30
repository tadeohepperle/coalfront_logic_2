import 'package:coalfront_logic_2/src/models/common/game_creation_config.dart';
import 'package:coalfront_logic_2/src/models/common/user.dart';
import 'package:coalfront_logic_2/src/models/game_state/player_state.dart';
import 'package:coalfront_logic_2/src/models/game_state/session_state.dart';
import 'package:coalfront_logic_2/src/models/player_actions/i_viewable.dart';
import 'package:dartz/dartz.dart';

import '../common/ids.dart';
import 'game_phase.dart';
import 'game_state_view.dart';
import 'map_state.dart';

class GameState implements IViewable<GameStateView, Unit> {
  GameState.initialFromConfig(GameCreationConfig config)
      : gamePhase = BeginningPhase(),
        gameId = config.gameId,
        mapState = MapState.initialFromConfig(config),
        sessionState = SessionState(
            owner: config.owner, playersJoined: [], players: config.players),
        playerStates = Map.fromEntries(
          config.players.map(
            (e) => MapEntry(
              e.userId,
              PlayerState.initial(),
            ),
          ),
        );

  GameId gameId;
  GamePhase gamePhase;
  MapState mapState;
  SessionState sessionState;
  Map<UserId, PlayerState> playerStates;

  @override
  getView(GameStateUnmodifyable gameState, User user) {
    // TODO: implement getView
    throw UnimplementedError();
  }
}

/// wrapper around GameState but only allows reads and no writes
class GameStateUnmodifyable {}
