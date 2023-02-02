import 'package:coalfront_logic_2/src/game_manager/i_game_manager_client_logger.dart';
import 'package:coalfront_logic_2/src/models/game_events/game_event.dart';
import 'package:coalfront_logic_2/src/models/player_input_actions/player_input_action.dart';
import 'package:coalfront_logic_2/src/models/ui_events/ui_event.dart';

import '../models/player_actions/player_action.dart';

class GameManagerClientLogger implements IGameManagerClientLogger {
  @override
  void logGameEventReceived(GameEvent gameEvent) {
    print("--- logGameEventReceived ---");
    print(gameEvent);
  }

  @override
  void logPlayerActionSent(PlayerAction playerAction) {
    print("--- logPlayerActionSent ---");
    print(playerAction);
  }

  @override
  void logPlayerInputActionReceived(PlayerInputAction playerInputAction) {
    print("--- logPlayerInputActionReceived ---");
    print(playerInputAction);
  }

  @override
  void logUiEventSent(UiEvent uiEvent) {
    print("--- logUiEventSend ---");
    print(uiEvent);
  }
}
