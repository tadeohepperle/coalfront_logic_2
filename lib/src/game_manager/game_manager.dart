import 'package:coalfront_logic_2/src/game_manager/i_game_manager.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_state.dart';
import 'package:coalfront_logic_2/src/models/player_actions/i_viewable.dart';
import 'package:coalfront_logic_2/src/models/player_actions/join_game_action.dart';
import 'package:coalfront_logic_2/src/models/player_actions/leave_game_action.dart';
import 'package:coalfront_logic_2/src/models/player_actions/player_action.dart';
import 'package:coalfront_logic_2/src/models/player_actions/player_action_result.dart';
import 'package:dartz/dartz.dart';

import '../models/common/game_creation_config.dart';
import 'failure_types.dart';

class GameManager implements IGameManager {
  GameState gameState;

  GameManager.newGame(GameCreationConfig config)
      : gameState = GameState.initialFromConfig(config);

  // todo change PlayerActionFailure everywhere to use subtypes
  Either<JoinFailure, JoinGameResult> handleJoin(JoinGameAction join) {
    return handleJoinGuard(join).fold((l) => left(l), (r) {
      gameState.sessionState.playersJoined.add(join.player);
      return right(JoinGameResult(joinedPlayer: join.player));
    });
  }

  Either<JoinFailure, Unit> handleJoinGuard(JoinGameAction join) {
    final joinUserId = join.player.userId;

    if (!gameState.sessionState.players
        .map((e) => e.userId)
        .contains(joinUserId)) {
      return left(JoinFailureNotPartOfThisGame());
    }
    if (gameState.sessionState.playersJoined.contains(joinUserId)) {
      return left(JoinFailureAlreadyInSession());
    }

    return right(unit);
  }

  @override
  Either<LeaveFailure, LeaveGameResult> handleLeave(LeaveGameAction leave) {
    return handleLeaveGuard(leave).fold((l) => left(l), (r) {
      gameState.sessionState.playersJoined.remove(leave.player.userId);
      return right(LeaveGameResult(playerThatLeft: leave.player));
    });
  }

  Either<LeaveFailure, Unit> handleLeaveGuard(LeaveGameAction leave) {
    if (!gameState.sessionState.players
        .map((e) => e.userId)
        .contains(leave.player.userId)) {
      return left(LeaveFailureWasNotJoined());
    }
    return right(unit);
  }
}
