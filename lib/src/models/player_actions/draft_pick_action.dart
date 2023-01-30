import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/player_actions/player_action.dart';
import 'package:coalfront_logic_2/src/models/player_actions/player_action_result.dart';

import '../common/user.dart';
import '../game_state/game_state.dart';

class DraftPickAction extends PlayerAction<DraftPickResult> {
  @override
  User player;
  CardInstanceId pick;
  DraftPickAction(
    this.player,
    this.pick,
  );
}

class DraftPickResult extends PlayerActionResult<DraftPickAction> {
  User player;
  CardInstanceId pick;
  DraftPickResult({
    required this.player,
    required this.pick,
  });

  @override
  DraftPickResultOthersView getOthersView(
          GameStateUnmodifyable gameState, User user) =>
      DraftPickResultOthersView(player: UserOthersView.fromUser(user));

  @override
  DraftPickResultSelfView getSelfView(
          GameStateUnmodifyable gameState, User user) =>
      DraftPickResultSelfView();
}

class DraftPickResultSelfView {}

class DraftPickResultOthersView {
  UserOthersView player;
  DraftPickResultOthersView({
    required this.player,
  });
}
