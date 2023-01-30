import 'package:coalfront_logic_2/src/models/player_actions/join_game_action.dart';
import 'package:dartz/dartz.dart';
import '../models/player_actions/draft_pick_action.dart';
import '../models/player_actions/leave_game_action.dart';
import 'failure_types.dart';

/// interface
abstract class IGameManager {
  void handleAction(JoinGameAction join);

  Either<JoinFailure, JoinGameResult> handleJoin(JoinGameAction join);
  Either<LeaveFailure, LeaveGameResult> handleLeave(LeaveGameAction leave);

  Either<DraftPickFailure, DraftPickResult> handleDraftPick(
      DraftPickAction draftPickAction);
}


/*

Either<TResult, Exception> receivePlayerAction<TResult extends IViewable>(
      PlayerAction<TResult> action) {
        
      }


*/
