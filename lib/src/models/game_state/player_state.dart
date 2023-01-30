import 'package:coalfront_logic_2/src/models/game_state/ingame/coalfront_card.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/coalfront_card_instance.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/coalfront_resource.dart';
import 'package:coalfront_logic_2/src/models/player_actions/i_viewable.dart';

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
