import 'package:coalfront_logic_2/src/models/common/ids.dart';

import '../models/game_events/game_event.dart';

/// keeps track of the maps the players reveived and simulates the GameManager clients.
/// This allows to check knowledge of players, e.g. player XYZ should know....
abstract class ISimulatedClientsManager {
  void receiveGameEvent(UserId userId, GameEvent gameEvent);
}
