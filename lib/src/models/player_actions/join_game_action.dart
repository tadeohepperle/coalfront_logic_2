import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_phase.dart';
import 'package:coalfront_logic_2/src/models/player_actions/i_viewable.dart';
import 'package:coalfront_logic_2/src/models/player_actions/player_action.dart';
import 'package:coalfront_logic_2/src/models/player_actions/player_action_result.dart';

import '../common/user.dart';
import '../game_state/game_state.dart';

class JoinGameAction extends PlayerAction<JoinGameResult> {
  @override
  UserId player;
  JoinGameAction(this.player);
}

class JoinGameResult
    extends PlayerActionResult<JoinGamePublicView, JoinGamePrivateData> {
  @override
  UserId player;
  @override
  GamePhase gamePhase;
  JoinGameResult({
    required this.player,
    required this.gamePhase,
  });

  @override
  JoinGamePublicView getView(GameStateUnmodifyable gameState, User user) {
    // TODO: implement getView
    throw UnimplementedError();
  }
}

class JoinGamePublicView extends PublicView<JoinGamePrivateData> {
  UserId player;
  GamePhaseView gamePhase;
  JoinGamePublicView({
    required this.player,
    required this.gamePhase,
  });
}

class JoinGamePrivateData {
  GameStateView gameState;

  JoinGamePrivateData({
    required this.player,
  });
}
