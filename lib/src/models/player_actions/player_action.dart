import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/player_actions/player_action_result.dart';

import 'i_viewable.dart';

/// sealed
abstract class PlayerAction {
  UserId get player;
}
