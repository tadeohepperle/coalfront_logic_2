import 'package:coalfront_logic_2/src/models/common/game_creation_config.dart';

import '../common/ids.dart';
import 'ingame/ingame_resource_bundle.dart';

/// resources and hand cards, lots of private information
class PlayerState {
  int winPoints;
  IngameResourceBundle netProduction;
  IngameResourceBundle resourcesLeft;
  List<CardInstanceId> handCards;
  PlayerState._({
    required this.netProduction,
    required this.resourcesLeft,
    required this.handCards,
    required this.winPoints,
  });

  factory PlayerState.initial() => PlayerState._(
        netProduction: IngameResourceBundle(),
        resourcesLeft: IngameResourceBundle(),
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
