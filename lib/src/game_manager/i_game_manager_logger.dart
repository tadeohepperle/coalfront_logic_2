import 'package:coalfront_logic_2/src/game_manager/failure_types.dart';
import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_events/game_event.dart';
import 'package:coalfront_logic_2/src/models/player_actions/player_action.dart';

abstract class IGameManagerLogger {
  void logAction(PlayerAction playerAction);

  void logActionFailure(PlayerActionFailure playerActionFailure);

  void logGameEventSent(UserId userId, GameEvent gameEvent);
}
