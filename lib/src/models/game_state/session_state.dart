import 'package:coalfront_logic_2/src/models/common/user.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_state.dart';
import '../common/ids.dart';

class SessionState {
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
