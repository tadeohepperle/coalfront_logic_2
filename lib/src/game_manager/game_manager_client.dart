import 'dart:async';

import 'package:coalfront_logic_2/src/game_manager/i_game_manager_client.dart';
import 'package:coalfront_logic_2/src/game_manager/i_game_manager_client_logger.dart';
import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/common/int2.dart';
import 'package:coalfront_logic_2/src/models/game_events/game_event.dart';
import 'package:coalfront_logic_2/src/models/game_events/game_state_view.dart';
import 'package:coalfront_logic_2/src/models/player_actions/player_action.dart';
import 'package:coalfront_logic_2/src/models/player_input_actions/player_input_action.dart';
import 'package:coalfront_logic_2/src/models/ui_events/ui_event.dart';

class GameManagerClient implements IGameManagerClient {
  ////////////////////////////////////////////////////////////////////////////////
  // Internal State
  ////////////////////////////////////////////////////////////////////////////////

  final IGameManagerClientLogger _logger;
  UserId userId;
  GameStateView? gameStateView;
  GameManagerClient({
    required IGameManagerClientLogger logger,
    required this.userId,
    this.gameStateView,
  }) : _logger = logger;

  /// sends stuff to UI
  final StreamController<UiEvent> _uiEventsController =
      StreamController<UiEvent>.broadcast();

  /// sends stuff to server
  final StreamController<PlayerAction> _playerActionsController =
      StreamController<PlayerAction>.broadcast();

  ////////////////////////////////////////////////////////////////////////////////
  // Public Two-Way Event Interface (towards Server and UI)
  ////////////////////////////////////////////////////////////////////////////////

  @override
  Stream<UiEvent> get uiEvents => _uiEventsController.stream;

  @override
  Stream<PlayerAction> get playerActions => _playerActionsController.stream;

  @override
  void receiveGameEvent(GameEvent gameEvent) {
    _logger.logGameEventReceived(gameEvent);

    /// dart3 switch pattern
    if (gameEvent is GameStateView) {
      return receiveGameStateView(gameEvent);
    }
  }

  @override
  void receivePlayerInputAction(PlayerInputAction playerInputAction) {
    _logger.logPlayerInputActionReceived(playerInputAction);
    if (playerInputAction is PlayerInputJoinGame) {
      _sendToServer(JoinGame(player: userId));
      _sendToUi(UiLoadingGame());
    }
    // todo
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Event Handler Functions
  ////////////////////////////////////////////////////////////////////////////////

  void receiveGameStateView(GameStateView gameStateView) {
    this.gameStateView = gameStateView;
    _sendToUi(LoadedGameState());
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Public Functions Interface
  ////////////////////////////////////////////////////////////////////////////////

  @override
  bool canSeeMapPosition(Int2 position) {
    // TODO: implement canSeeMapPosition
    throw UnimplementedError();
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Helper Functions
  ////////////////////////////////////////////////////////////////////////////////

  void _sendToServer(PlayerAction playerAction) {
    _logger.logPlayerActionSent(playerAction);
    _playerActionsController.add(playerAction);
  }

  void _sendToUi(UiEvent uiEvent) {
    _logger.logUiEventSent(uiEvent);
    _uiEventsController.add(uiEvent);
  }
}
