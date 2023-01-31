import 'package:coalfront_logic_2/src/models/common/game_creation_config.dart';

import '../common/ids.dart';
import 'ingame/ingame_resource_bundle.dart';

/// resources and hand cards, lots of private information
class PlayerState {
  int winPoints;
  IngameResourceBundle earningEveryTurn;
  IngameResourceBundle stillAvailableThisTurn;
  List<CardInstanceId> handCards;
  PlayerState._({
    required this.earningEveryTurn,
    required this.stillAvailableThisTurn,
    required this.handCards,
    required this.winPoints,
  });

  factory PlayerState.initial() => PlayerState._(
        earningEveryTurn: IngameResourceBundle.initialFromJustBaseBuilding(),
        stillAvailableThisTurn:
            IngameResourceBundle.initialFromJustBaseBuilding(),
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
          e.id,
          PlayerState.initial(),
        ),
      ),
    );
    return PlayerStates(states: states);
  }
}
