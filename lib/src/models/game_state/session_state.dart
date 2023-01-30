import 'package:coalfront_logic_2/src/models/common/user.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_state.dart';
import 'package:coalfront_logic_2/src/models/player_actions/i_viewable.dart';
import 'package:dartz/dartz.dart';

import '../common/ids.dart';

class SessionState extends PublicView<Unit>
    implements IViewable<SessionState, Unit> {
  UserId owner;
  List<User> players;
  List<UserId> playersJoined;
  SessionState({
    required this.owner,
    required this.playersJoined,
    required this.players,
  });

  @override
  SessionState getView(GameStateUnmodifyable gameState, User user) => this;
}
