import 'package:coalfront_logic_2/src/models/game_events/game_event.dart';
import 'package:coalfront_logic_2/src/models/player_input_actions/player_input_action.dart';
import 'package:coalfront_logic_2/src/models/ui_events/ui_event.dart';

import '../models/player_actions/player_action.dart';

abstract class IGameManagerClientLogger {
  void logPlayerActionSent(PlayerAction playerAction);
  void logUiEventSent(UiEvent uiEvent);

  void logPlayerInputActionReceived(PlayerInputAction playerInputAction);
  void logGameEventReceived(GameEvent gameEvent);

  /// todo: log failures
}
