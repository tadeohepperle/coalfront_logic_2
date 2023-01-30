import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_phase.dart';
import 'i_viewable.dart';

/// sealed
abstract class PlayerActionResult<Pub extends PublicView<Priv>, Priv>
    implements IViewable<Pub, Priv> {
  UserId get player;
  GamePhase get gamePhase;
}
