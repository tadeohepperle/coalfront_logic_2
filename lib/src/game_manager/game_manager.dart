import 'dart:async';

import 'package:coalfront_logic_2/src/game_manager/simulated_clients_manager.dart';
import 'package:dartz/dartz.dart';

import 'package:coalfront_logic_2/src/game_manager/failure_types.dart';
import 'package:coalfront_logic_2/src/game_manager/game_manager_logger.dart';
import 'package:coalfront_logic_2/src/game_manager/i_game_manager_client.dart';
import 'package:coalfront_logic_2/src/game_manager/i_game_manager_logger.dart';
import 'package:coalfront_logic_2/src/game_manager/i_simulated_clients_manager.dart';
import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/common/user.dart';
import 'package:coalfront_logic_2/src/models/game_events/construct_map_state_and_index_view.dart';
import 'package:coalfront_logic_2/src/models/game_events/game_event.dart';
import 'package:coalfront_logic_2/src/models/game_events/game_phase_view.dart';
import 'package:coalfront_logic_2/src/models/game_events/game_state_view.dart';
import 'package:coalfront_logic_2/src/models/game_state/functions/functions.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_phase.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_phase_transitioning.dart';
import 'package:coalfront_logic_2/src/models/game_state/i_resources_index.dart';
import 'package:coalfront_logic_2/src/models/game_state/id_index_structure.dart';
import 'package:coalfront_logic_2/src/models/game_state/indexable_resource.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/building.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/card_instance.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/ingame_resource_bundle.dart';
import 'package:coalfront_logic_2/src/models/game_state/library_state.dart';
import 'package:coalfront_logic_2/src/models/player_actions/player_action.dart';

import '../constants.dart';
import '../models/common/game_creation_config.dart';
import '../models/common/int2.dart';
import '../models/game_state/game_state.dart';
import '../models/game_state/ingame/tile_type.dart';
import 'i_game_manager.dart';

class GameManager implements IGameManager {


  ////////////////////////////////////////////////////////////////////////////////
  // Internal State
  ////////////////////////////////////////////////////////////////////////////////

  final IGameManagerLogger _logger;
  final ISimulatedClientsManager _simulatedClientsManager;
  final GameState _gameState;

  GameManager._({
    required  IGameManagerLogger logger,
    required ISimulatedClientsManager simulatedClientsManager,
    required GameState gameState,
  }) : _gameState = gameState, _logger = logger, _simulatedClientsManager = simulatedClientsManager;

  factory GameManager.newFromGameConfig(GameCreationConfig config){
    final logger = GameManagerLogger();
    final gameState = GameState.initialFromConfig(config);
    final simulatedClientsManager = SimulatedClientsManager.fromGameState(gameState);
return GameManager._(logger: logger, simulatedClientsManager: simulatedClientsManager, gameState: gameState);
  }

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
      } else if (gameAction is MakePlay) {
        return handleMakePlay(gameAction);
      } else if (gameAction is PassTurn) {
        return handlePassTurn(gameAction);
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
        GameStateView.fromState(_gameState, thisPlayer),
      );
      return JoinFailureAlreadyInSession();
    } else {
      _gameState.sessionState.playersJoined.add(thisPlayer);
      if (_gameState.gamePhase is BeginningPhase && _allPlayersJoined) {
        final draftPhaseCreated = getNewDraftPhaseFromLibrary();
        _gameState.gamePhase = RunningPhase(1, draftPhaseCreated);
      }
      _sendToPlayer(
        thisPlayer,
        GameStateView.fromState(_gameState, thisPlayer),
      );
      _sendToOtherPlayers(
        thisPlayer,
        (otherUserId) => PlayerJoined(
          gamePhaseView: GamePhaseView.fromGamePhase(
            _gameState.gamePhase,
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
    _gameState.sessionState.playersJoined.remove(thisPlayer);
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
    return guardAgainstWrongTurnPhase<DraftPhase>().fold((l) => l, (tuple) {
      final draftPhase = tuple.value2;
      final runningPhase = tuple.value1;
      ////////////////////////////////////////
      // Guards

      if (draftPhase.draftRounds.last.picksMade[thisPlayer] != null) {
        return DraftPickFailurePickAlreadyMade();
      }
      final playerPickOptions =
          draftPhase.draftRounds.last.pickOptions[thisPlayer]!;
      if (!playerPickOptions.contains(draftPick.cardInstanceId)) {
        return DraftPickFailureCardNotInPicks();
      }

      ////////////////////////////////////////
      // Logic

      final pick = draftPick.cardInstanceId;
      draftPhase.draftRounds.last.picksMade[thisPlayer] = pick;
      _gameState.playerStates[thisPlayer].handCards.add(pick);
      if (draftPhase.draftRounds.last.picksMade.values.length ==
          _allPlayers.length) {
        // go to play phase or to next draftround.
        _gameState.gamePhase = RunningPhase(
            runningPhase.turn, draftPhase.transitionToPlayPhaseOrNextRound());
      }

      ////////////////////////////////////////
      // Events

      _sendToAllPlayers((userId) => DraftPickDone(
            gamePhaseView:
                GamePhaseView.fromGamePhase(_gameState.gamePhase, userId),
            userId: thisPlayer,
          ));
      return null;
    });
  }

  // note: was PassTurnFailure before but could not express it properly with generic type bounds in guard function.
  PlayerActionFailure? handlePassTurn(PassTurn passTurn) {
    final thisPlayer = passTurn.player;

    return guardAgainstWrongEndedTurnAndNotPlayersTurnInPlayPhase(thisPlayer)
        .fold((l) => l, (tuple) {
      final playPhase = tuple.value2;
      final runningPhase = tuple.value1;
      ////////////////////////////////////////
      // Logic

      if (passTurn.endTurn) {
        playPhase.endedTurn.add(thisPlayer);
        playPhase.passedCount[thisPlayer] = 10000;
      } else {
        playPhase.passedCount[thisPlayer] =
            playPhase.passedCount[thisPlayer]! + 1;
      }

      // phase transitions:

      final bool allPlayersThatHaveNotEndedturnPassedAtLeastTwice = playPhase
          .playOrder
          .toSet()
          .difference(playPhase.endedTurn.toSet())
          .every((userId) => playPhase.passedCount[userId]! >= 2);
      if (allPlayersThatHaveNotEndedturnPassedAtLeastTwice) {
        // go to endphase or directly to next turn:
        _gameState.gamePhase =
            RunningPhase(runningPhase.turn, playPhase.transitionToEndPhase());
      } else {
        // pass initiative to next player -> becomes active player
        final nextPlayer =
            playPhase.playOrder.nextWithLooping(playPhase.activePlayer);
        playPhase.activePlayer = nextPlayer;
      }

      ////////////////////////////////////////
      // Events

      // bc playPhase is reference type, when we change values on it these are also changed in gameState.gamePhase.
      _sendToAllPlayers((userId) => PlayerPassed(
            gamePhaseView:
                GamePhaseView.fromGamePhase(_gameState.gamePhase, userId),
            userId: userId,
            endTurn: passTurn.endTurn,
          ));

      return null;
    });
  }

  // note: was MakePlayFailure before but could not express it properly with generic type bounds in guard function.
  PlayerActionFailure? handleMakePlay(MakePlay makePlay) {
    return guardAgainstWrongEndedTurnAndNotPlayersTurnInPlayPhase(
            makePlay.player)
        .fold((l) => l, (tuple) {
      final playPhase = tuple.value2;
      final runningPhase = tuple.value1;

      /// dart3 replace with switch statement
      if (makePlay is BuildBuilding) {
        return handleBuildBuilding(makePlay, playPhase, runningPhase);
      } else if (makePlay is CastSpell) {
        return handleCastSpell(makePlay, playPhase, runningPhase);
      }
      throw Exception(
          "exhaustive check for MakePlay actions! $makePlay is not included");
    });
  }

  /// BuildBuilding:
  ///
  /// 1. check Id collision
  /// 2. check if cost payable
  /// 3. check if space free and terrain type matches
  ///
  /// - register building (inlcudes map occupation)
  /// - pay cost
  /// - set player passed count to 0
  MakePlayFailure handleBuildBuilding(BuildBuilding buildBuilding,
      PlayPhase playPhase, RunningPhase runningPhase) {
    final thisPlayer = buildBuilding.player;
    final BuildingCardInstance buildingCardInstance = indexStructure
            .resolve<CardInstance, CardInstanceId>(buildBuilding.cardInstanceId)
        as BuildingCardInstance;
    // check for id collision:
    if (indexStructure.tryResolve<Building, BuildingId>(buildBuilding.buildingId) != null) {
      return BuildBuildingFailureIdCollision();
    }
    // check that player has enough resources:
    if (!playerCanPayCost(thisPlayer, buildingCardInstance.card.cost)) {
      return BuildBuildingFailureCannotPayCost();
    }
    // check if space is occupied

    final worldPositions = positionRotationAndRelativePositionsToWorldPositions(
        buildBuilding.position,
        buildBuilding.rotation,
        buildingCardInstance.card.properties.relativePositions);
    final suitableTiles =  buildingCardInstance.card.properties.suitableTiles;
    if (!spaceIsFreeAndTilesAreOk(worldPositions, suitableTiles)) {
      return BuildBuildingFailureSpaceOccupied();
    }

    // register building (inlcudes map occupation and player netProduction update)
    final Building building = Building(id: buildBuilding.buildingId, positions: worldPositions, buildingType: );
    _gameState.registerBuilding(building);
    // pay cost
    final playerState = _gameState.playerStates[thisPlayer];
    playerState.resourcesLeft -= buildingCardInstance.card.cost;
    // set player passed count to 0
    playPhase.passedCount[thisPlayer] = 0;

    
    todo what events to send out

  }

  MakePlayFailure handleCastSpell(
      CastSpell castSpell, PlayPhase playPhase, RunningPhase runningPhase) {
    // todo!!!!! set passedCount to 0!

    throw "todo";
  }

  // todo: cast spell

  ////////////////////////////////////////////////////////////////////////////////
  // Mutating State Functions
  ////////////////////////////////////////////////////////////////////////////////

  /// mutates the library!!
  DraftPhase getNewDraftPhaseFromLibrary() {
    final int totalCardsNeeded = userIds.length * DRAFT_PICK_OPTION_COUNT;
    final libraryCardCount = _gameState.libraryState.cardCount;
    if (totalCardsNeeded > libraryCardCount) {
      throw Exception(
          "Error: Library does not have enough cards ($totalCardsNeeded needed, $libraryCardCount left)");
    }
    final List<CardInstanceId> allPickOptions =
        _gameState.libraryState.popTop(totalCardsNeeded);
    allPickOptions.shuffle();

    final initialPickOptionsPerPlayer = userIds.map((userId) =>
        MapEntry(userId, allPickOptions.popTop(DRAFT_PICK_OPTION_COUNT)));

    final DraftRound firstDraftRound = DraftRound(
      pickOptions: Map.fromEntries(initialPickOptionsPerPlayer),
      picksMade: {},
      roundNumber: 1,
    );
    return DraftPhase(
        playOrder: determinePlayOrder(),
        finalTotalRounds: DRAFT_PICK_OPTION_COUNT,
        draftRounds: [firstDraftRound]);
  }


  
  

  ////////////////////////////////////////////////////////////////////////////////
  // Nonmutating Functions
  ////////////////////////////////////////////////////////////////////////////////

  /// done every time a season starts (beginning of DraftPhase)
  List<UserId> determinePlayOrder() {
    // todo in future: maybe winpoints determine playorder
    final playOrder = [...indexStructure.userIds];
    playOrder.shuffle();
    return playOrder;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Helper Functions
  ////////////////////////////////////////////////////////////////////////////////

  bool playerCanPayCost(UserId user, IngameResourceBundle cost) {
    final playerState = _gameState.playerStates[user];
    return playerState.resourcesLeft.contains(cost);
  }

  bool spaceIsFreeAndTilesAreOk(
    List<Int2> worldPositions, Iterable<TileType> suitableTiles) {
    for (final pos in worldPositions) {
      if (!_gameState.mapState.isInBounds(pos) ||
          _gameState.mapState.occupiedTiles[pos] != null ||
          !suitableTiles.contains(_gameState.mapState[pos])) {
        return false;
      }
    }
    return true;
  }

  /// dart3 replace tuple
  Either<PlayerActionFailureWrongPhase, Tuple2<RunningPhase, T>>
      guardAgainstWrongTurnPhase<T extends TurnPhase>() {
    final gamePhase = _gameState.gamePhase;
    if (gamePhase is! RunningPhase) {
      return left(PlayerActionFailureWrongPhase());
    }
    var turnPhase = gamePhase.turnPhase;
    if (turnPhase is! T) {
      return left(PlayerActionFailureWrongPhase());
    }
    return right(Tuple2(gamePhase, turnPhase));
  }

  Either<PlayerActionFailure, Tuple2<RunningPhase, PlayPhase>>
      guardAgainstWrongEndedTurnAndNotPlayersTurnInPlayPhase<T>(
          UserId thisPlayer) {
    return guardAgainstWrongTurnPhase<PlayPhase>().fold((l) => left(l),
        (tuple) {
      final playPhase = tuple.value2;
      final runningPhase = tuple.value1;

      if (playPhase.endedTurn.contains(thisPlayer)) {
        return left(PlayerActionFailureAlreadyEndedTurn());
      }
      if (playPhase.activePlayer != thisPlayer) {
        return left(PlayerActionFailureNotPlayersTurn());
      }
      return right(Tuple2(runningPhase, playPhase));
    });
  }

  void _sendToPlayer(UserId userId, GameEvent gameEvent) {
    _logger.logGameEventSent(userId, gameEvent);
    _eventsController.add(Tuple2(userId, gameEvent));
    _simulatedClientsManager.receiveGameEvent(userId, gameEvent);
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

  @pragma("vm:prefer-inline")
  IdIndexStructure get indexStructure => _gameState.indexStructure;

  bool _playerNotPartOfGame(UserId player) =>
      !indexStructure.userIds.contains(player);

  bool _isJoined(UserId userId) => _joinedPlayers.contains(userId);

  @pragma("vm:prefer-inline")
  Iterable<UserId> get _joinedPlayers => _gameState.sessionState.playersJoined;

  @pragma("vm:prefer-inline")
  Iterable<User> get _allPlayers => indexStructure.users;

  Iterable<UserId> _joinedPlayersExcept(UserId userId) =>
      _joinedPlayers.where((e) => e != userId);

  bool get _allPlayersJoined =>
      _allPlayers.every((u) => _joinedPlayers.contains(u.id));

  bool _isOwner(UserId userId) => _gameState.sessionState.owner == userId;

  Iterable<UserId> get userIds => indexStructure.userIds;

  void _endGameCleanUp() {
    _eventsController.close();
    _logger.close();
  }
}
