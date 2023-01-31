import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/coalfront_building.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/coalfront_card.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/coalfront_card_instance.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/coalfront_hap.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/coalfront_hap_instance.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/coalfront_resource_bundle.dart';

class LibraryState {
  List<CoalfrontCardInstance> cards; // card deck (for player draws)
  List<CoalfrontHapInstance> haps; // event deck
  LibraryState({
    required this.cards,
    required this.haps,
  });

  /// todo: this is just test
  factory LibraryState.testDecks() {
    final BuildingCard testBuidlingCard = CoalfrontCard(
      cardId: "1a",
      name: "Test building",
      cost: CoalfrontResourceBundle(),
      properties: BuildingCardProperties(
        turnCost: CoalfrontResourceBundle(),
        turnEarning: CoalfrontResourceBundle(),
      ),
    );

    final cards = List.generate(
      10,
      (index) => BuildingCardInstance(
        card: testBuidlingCard,
        cardInstanceId: generateUniqueId(),
      ),
    );

    final testHap = CoalfrontHap(delay: 0, hapId: generateUniqueId());

    final haps = List.generate(
      20,
      (index) =>
          CoalfrontHapInstance(hapInstanceId: generateUniqueId(), hap: testHap),
    );

    return LibraryState(cards: cards, haps: haps);
  }
}
