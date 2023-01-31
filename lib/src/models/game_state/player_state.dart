import 'package:coalfront_logic_2/src/models/common/game_creation_config.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/coalfront_card.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/coalfront_card_instance.dart';

import '../common/ids.dart';
import 'ingame/coalfront_resource_bundle.dart';

/// resources and hand cards, lots of private information
class PlayerState {
  int winPoints;
  CoalfrontResourceBundle earningEveryTurn;
  CoalfrontResourceBundle stillAvailableThisTurn;
  List<CoalfrontCardInstance> handCards;
  PlayerState._({
    required this.earningEveryTurn,
    required this.stillAvailableThisTurn,
    required this.handCards,
    required this.winPoints,
  });

  factory PlayerState.initial() => PlayerState._(
        earningEveryTurn: CoalfrontResourceBundle.initialFromJustBaseBuilding(),
        stillAvailableThisTurn:
            CoalfrontResourceBundle.initialFromJustBaseBuilding(),
        handCards: [],
        winPoints: 0,
      );
}

class PlayerStates {
  Map<UserId, PlayerState> states;
  PlayerStates({
    required this.states,
  });

  PlayerState operator [](UserId index) => states[index]!;

  factory PlayerStates.initialFromConfig(GameCreationConfig config) {
    final states = Map.fromEntries(
      config.players.map(
        (e) => MapEntry(
          e.userId,
          PlayerState.initial(),
        ),
      ),
    );
    return PlayerStates(states: states);
  }
}
