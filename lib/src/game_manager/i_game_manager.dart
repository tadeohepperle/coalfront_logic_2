import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/player_actions/player_action.dart';
import 'package:dartz/dartz.dart';
import '../models/game_events/game_event.dart';
import 'failure_types.dart';

/// dart3 interface
abstract class IGameManager {
  PlayerActionFailure? handleAction(PlayerAction gameAction);

  /// replace dart3 records
  Stream<Tuple2<UserId, GameEvent>> get events;
}
