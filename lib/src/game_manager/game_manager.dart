import 'dart:async';

import 'package:coalfront_logic_2/src/game_manager/game_manager_logger.dart';
import 'package:coalfront_logic_2/src/game_manager/i_game_manager_logger.dart';
import 'package:coalfront_logic_2/src/models/common/user.dart';
import 'package:coalfront_logic_2/src/models/game_events/game_event.dart';
import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_events/game_phase_view.dart';
import 'package:coalfront_logic_2/src/models/game_events/join_initial_data_load.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_phase.dart';
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
  // Internal State
  ////////////////////////////////////////////////////////////////////////////////

  final IGameManagerLogger _logger = GameManagerLogger();
  final GameState gameState;

  final StreamController<Tuple2<UserId, GameEvent>> _eventsController =
      StreamController<Tuple2<UserId, GameEvent>>.broadcast();

  ////////////////////////////////////////////////////////////////////////////////
  // Public Interface
  ////////////////////////////////////////////////////////////////////////////////

  @override
  PlayerActionFailure? handleAction(PlayerAction gameAction) {
    _logger.logAction(gameAction);
    if (_playerNotPartOfGame(gameAction.player)) {
      return PlayerActionFailureNotPartOfThisGame();
    }
    final PlayerActionFailure? failureOrNull = () {
      /// dart3 switch pattern and remove this stupid IIFE.
      if (gameAction is JoinGame) {
        return handleJoinGame(gameAction);
      }
      // all other actions except join need the player to be joined so we check that here.
      if (!_isJoined(gameAction.player)) {
        return PlayerActionFailureWasNotJoined();
      }
      if (gameAction is LeaveGame) {
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
    return _logged(failureOrNull);
  }

  @override
  Stream<Tuple2<UserId, GameEvent>> get events => _eventsController.stream;

  ////////////////////////////////////////////////////////////////////////////////
  // Handler Functions
  ////////////////////////////////////////////////////////////////////////////////

  JoinFailure? handleJoinGame(JoinGame joinGame) {
    final thisPlayer = joinGame.player;
    if (_isJoined(thisPlayer)) {
      _sendToPlayer(
        thisPlayer,
        GameStateView.fromState(gameState, thisPlayer),
      );
      return JoinFailureAlreadyInSession();
    } else {
      gameState.sessionState.playersJoined.add(thisPlayer);
      if (gameState.gamePhase is BeginningPhase && _allPlayersJoined) {
        gameState.gamePhase = RunningPhase.initial();
      }
      _sendToPlayer(
        thisPlayer,
        GameStateView.fromState(gameState, thisPlayer),
      );
      _sendToOtherPlayers(
        thisPlayer,
        (otherUserId) => PlayerJoined(
          gamePhaseView: GamePhaseView.fromGamePhase(
            gameState.gamePhase,
            otherUserId,
          ),
          userId: thisPlayer,
        ),
      );
      return null;
    }

    /// deprecated: return JoinFailureAlreadyInSession();  if already joined
    /// we just send the player a new session of the gamestate and keep him joined. No need to not accept his join.
    /// Example: Player kills the game, starts again
    /// before server notices that player is offline and could make him leave.
    /// The standard procedure is that if a Server notices a player is Offline for too long (no ping response for some time)
    /// He kicks him out (LeaveGame action) sucht that other players get notified that this player disjoined.
    /// Future: todo: seperate Kickout Action for this???? Should players see that player lost connection
    /// instead of seeing that he left, to distingiush voluntary and forced LeaveGame actions???
    /// Future: todo: Option for a player to surrender and other players keep playing in the game session???
  }

  LeaveFailure? handleLeaveGame(LeaveGame leaveGame) {
    final thisPlayer = leaveGame.player;
    gameState.sessionState.playersJoined.remove(thisPlayer);
    _sendToAllPlayers((userId) => PlayerLeft(userId: userId));
    return null;
  }

  EndGameFailure? handleEndGame(EndGame endGame) {
    final thisPlayer = endGame.player;
    if (!_isOwner(thisPlayer)) {
      return EndGameFailureNotTheOwner();
    }
    _sendToAllPlayers((userId) => GameWasEnded(userId: thisPlayer));
    _endGameCleanUp();
    return null;
  }

  DraftPickFailure? handleDraftPick(DraftPick draftPick) {
    final thisPlayer = draftPick.player;

    ////////////////////////////////////////
    // Guards

    /// dart3 replace with switch pattern
    final gamePhase = gameState.gamePhase;
    if (gamePhase is! RunningPhase) {
      return DraftPickFailurePhaseIsNotDraftPhase();
    }
    var turnPhase = gamePhase.turnPhase;
    if (turnPhase is! DraftPhase) {
      return DraftPickFailurePhaseIsNotDraftPhase();
    }
    if (turnPhase.picksMade[thisPlayer] != null) {
      return DraftPickFailurePickAlreadyMade();
    }
    final playerPickOptions = turnPhase.pickOptions[thisPlayer]!;
    if (!playerPickOptions.contains(draftPick.cardInstanceId)) {
      return DraftPickFailureCardNotInPicks();
    }

    ////////////////////////////////////////
    // Logic

    final pick = draftPick.cardInstanceId;
    turnPhase.picksMade[thisPlayer] = pick;
    gameState.playerStates[thisPlayer].handCards.add(pick);
    if (turnPhase.picksMade.values.length == _allPlayers.length) {
      // transition to PlayPhase:
      final playOrder = gameState.indexStructure.userIds.toList();
      playOrder.shuffle();
      turnPhase = PlayPhase(playOrder: playOrder, activePlayer: playOrder[0]);
      gameState.gamePhase = RunningPhase(turnPhase);
    }

    ////////////////////////////////////////
    // Events

    _sendToAllPlayers((userId) => DraftPickDone(
          gamePhaseView: GamePhaseView.fromGamePhase(gamePhase, userId),
          userId: thisPlayer,
        ));
  }

  PassTurnFailure? handlePassTurn(PassTurn passTurn) {
    throw "todo";
  }

  MakePlayFailure? handleMakePlay(MakePlay makePlay) {
    throw "todo";
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Helper Functions
  ////////////////////////////////////////////////////////////////////////////////

  void _sendToPlayer(UserId userId, GameEvent gameEvent) {
    _logger.logGameEventSent(userId, gameEvent);
    _eventsController.add(Tuple2(userId, gameEvent));
  }

  void _sendToOtherPlayers(
      UserId userId, GameEvent Function(UserId otherUserId) fn) {
    for (final otherUserId in _joinedPlayersExcept(userId)) {
      _sendToPlayer(otherUserId, fn(otherUserId));
    }
  }

  void _sendToAllPlayers(GameEvent Function(UserId userId) fn) {
    for (final userId in _joinedPlayers) {
      _sendToPlayer(userId, fn(userId));
    }
  }

  PlayerActionFailure? _logged(PlayerActionFailure? failure) {
    if (failure != null) {
      _logger.logActionFailure(failure);
    }
    return failure;
  }

  bool _playerNotPartOfGame(UserId player) =>
      !gameState.indexStructure.userIds.contains(player);

  bool _isJoined(UserId userId) => _joinedPlayers.contains(userId);

  @pragma("vm:prefer-inline")
  Iterable<UserId> get _joinedPlayers => gameState.sessionState.playersJoined;

  @pragma("vm:prefer-inline")
  Iterable<User> get _allPlayers => gameState.indexStructure.users;

  Iterable<UserId> _joinedPlayersExcept(UserId userId) =>
      _joinedPlayers.where((e) => e != userId);

  bool get _allPlayersJoined =>
      _allPlayers.every((u) => _joinedPlayers.contains(u.id));

  bool _isOwner(UserId userId) => gameState.sessionState.owner == userId;

  void _endGameCleanUp() {
    _eventsController.close();
    _logger.close();
  }
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
