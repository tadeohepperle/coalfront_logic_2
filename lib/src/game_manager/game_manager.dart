import 'dart:async';

import 'package:coalfront_logic_2/src/game_manager/game_manager_logger.dart';
import 'package:coalfront_logic_2/src/game_manager/i_game_manager_logger.dart';
import 'package:coalfront_logic_2/src/models/game_events/game_event.dart';
import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:dartz/dartz.dart';

import 'package:coalfront_logic_2/src/models/player_actions/player_action.dart';

import 'package:coalfront_logic_2/src/game_manager/failure_types.dart';

import '../models/common/game_creation_config.dart';
import '../models/game_state/game_state.dart';
import 'i_game_manager.dart';

class GameManager implements IGameManager {
  GameManager.newGame(GameCreationConfig config)
      : gameState = GameState.initialFromConfig(config);

  ////////////////////////////////////////////////////////////////////////////////
  /// Internal State
  ////////////////////////////////////////////////////////////////////////////////

  final IGameManagerLogger _logger = GameManagerLogger();
  final GameState gameState;

  final StreamController<Tuple2<UserId, GameEvent>> _eventsController =
      StreamController<Tuple2<UserId, GameEvent>>.broadcast();

  ////////////////////////////////////////////////////////////////////////////////
  /// Public Interface
  ////////////////////////////////////////////////////////////////////////////////

  @override
  PlayerActionFailure? handleAction(PlayerAction gameAction) {
    final PlayerActionFailure? failureOrNull = () {
      /// dart3 switch pattern and remove this stupid IIFE.
      if (gameAction is JoinGame) {
        return handleJoinGame(gameAction);
      } else if (gameAction is LeaveGame) {
        return handleLeaveGame(gameAction);
      } else if (gameAction is EndGame) {
        return handleEndGame(gameAction);
      } else if (gameAction is DraftPick) {
        return handleDraftPick(gameAction);
      } else if (gameAction is LeaveGame) {
        return handleLeaveGame(gameAction);
      } else if (gameAction is LeaveGame) {
        return handleLeaveGame(gameAction);
      }
    }();
    return logged(failureOrNull);
  }

  @override
  Stream<Tuple2<UserId, GameEvent>> get events => _eventsController.stream;

  ////////////////////////////////////////////////////////////////////////////////
  /// Handler Functions
  ////////////////////////////////////////////////////////////////////////////////

  JoinFailure? handleJoinGame(JoinGame joinGame) {
    if (playerNotInSession(joinGame)) {
      return JoinFailureNotPartOfThisGame();
    }
    if (playerIsJoined(joinGame)) {
      // final  joinDataLoad
      // sendGameEventToPlayer()
      return null;

      /// deprecated: return JoinFailureAlreadyInSession();
      /// we just send the player a new session of the gamestate and keep him joined. No need to not accept his join.
      /// Example: Player kills the game, starts again
      /// before server notices that player is offline and could make him leave.
      /// The standard procedure is that if a Server notices a player is Offline for too long (no ping response for some time)
      /// He kicks him out (LeaveGame action) sucht that other players get notified that this player disjoined.
      /// Future: todo: seperate Kickout Action for this???? Should players see that player lost connection
      /// instead of seeing that he left, to distingiush voluntary and forced LeaveGame actions???
      /// Future: todo: Option for a player to surrender and other players keep playing in the game session???
    }
  }

  LeaveFailure? handleLeaveGame(LeaveGame leaveGame) {
    throw "todo";
  }

  EndGameFailure? handleEndGame(EndGame endGame) {
    throw "todo";
  }

  DraftPickFailure? handleDraftPick(DraftPick draftPick) {
    throw "todo";
  }

  PassTurnFailure? handlePassTurn(PassTurn passTurn) {
    throw "todo";
  }

  MakePlayFailure? handleMakePlay(MakePlay makePlay) {
    throw "todo";
  }

  ////////////////////////////////////////////////////////////////////////////////
  /// Helper Functions
  ////////////////////////////////////////////////////////////////////////////////

  void sendGameEventToPlayer(GameEvent gameEvent, UserId userId) {
    _eventsController.add(Tuple2(userId, gameEvent));
  }

  PlayerActionFailure? logged(PlayerActionFailure? failure) {
    if (failure != null) {
      _logger.logActionFailure(failure);
    }
    return failure;
  }

  bool playerNotInSession(PlayerAction playerAction) =>
      gameState.sessionState.players
          .indexWhere((e) => e.userId == playerAction.player) ==
      -1;

  bool playerIsJoined(PlayerAction playerAction) =>
      gameState.sessionState.playersJoined.contains(playerAction.player);
}

/*

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

*/
