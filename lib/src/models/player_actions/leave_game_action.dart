import 'package:dartz/dartz.dart';

import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_phase.dart';
import 'package:coalfront_logic_2/src/models/player_actions/i_viewable.dart';
import 'package:coalfront_logic_2/src/models/player_actions/player_action.dart';
import 'package:coalfront_logic_2/src/models/player_actions/player_action_result.dart';

import '../common/user.dart';
import '../game_state/game_state.dart';

class LeaveGameAction extends PlayerAction {
  @override
  UserId player;
  LeaveGameAction(this.player);
}

class LeaveGameResult extends PlayerActionResult<LeaveGamePublicView, Unit> {
  @override
  UserId player;
  @override
  GamePhase gamePhase;
  LeaveGameResult({
    required this.player,
    required this.gamePhase,
  });

  @override
  LeaveGamePublicView getView(GameStateUnmodifyable gameState, User user) =>
      LeaveGamePublicView(
          player: player, gamePhase: gamePhase.getView(gameState, user));
}

class LeaveGamePublicView extends PublicView<Unit> {
  UserId player;
  GamePhaseView gamePhase;

  LeaveGamePublicView({
    required this.player,
    required this.gamePhase,
  });
}
