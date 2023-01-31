import 'package:coalfront_logic_2/src/models/player_actions/player_action.dart';

import 'package:coalfront_logic_2/src/models/game_events/game_event.dart';

import 'package:coalfront_logic_2/src/models/common/ids.dart';

import 'package:coalfront_logic_2/src/game_manager/failure_types.dart';

import 'i_game_manager_logger.dart';

class GameManagerLogger implements IGameManagerLogger {
  @override
  void logAction(PlayerAction playerAction) {
    print("--- logAction ---");
    print(playerAction);
  }

  @override
  void logActionFailure(PlayerActionFailure playerActionFailure) {
    print("--- logActionFailure ---");
    print(playerActionFailure);
  }

  @override
  void logGameEventSent(UserId userId, GameEvent gameEvent) {
    print("--- logGameEventSent ---");
    print(userId);
    print(gameEvent);
  }
}
