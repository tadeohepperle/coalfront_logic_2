import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_state/player_state.dart';

class PlayerStatesView {
  PlayerStateSelfView self;
  Map<UserId, PlayerStateOthersView> others;
  PlayerStatesView({
    required this.self,
    required this.others,
  });

  factory PlayerStatesView.fromPlayerStates(
      PlayerStates playerStates, UserId user) {
    final othersMapEntries =
        playerStates.states.entries.where((e) => e.key != user).map(
              (e) => MapEntry(
                  e.key, PlayerStateOthersView.fromPlayerState(e.value, user)),
            );
    return PlayerStatesView(
        self: playerStates[user], others: Map.fromEntries(othersMapEntries));
  }
}

/// todo: might need update in future to be own class
typedef PlayerStateSelfView = PlayerState;

class PlayerStateOthersView {
  int winPoints;
  int numHandCards;
  PlayerStateOthersView({
    required this.winPoints,
    required this.numHandCards,
  });

  factory PlayerStateOthersView.fromPlayerState(
          PlayerState playerState, UserId user) =>
      PlayerStateOthersView(
        winPoints: playerState.winPoints,
        numHandCards: playerState.handCards.length,
      );
}
