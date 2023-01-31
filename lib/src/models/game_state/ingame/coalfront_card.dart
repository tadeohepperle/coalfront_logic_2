import 'package:coalfront_logic_2/src/models/game_state/ingame/coalfront_resource_bundle.dart';

import '../../common/ids.dart';

class CoalfrontCard<C extends CoalfrontCardTypeProperties> {
  CardId cardId;
  String name;
  CoalfrontResourceBundle cost;
  C properties;
  CoalfrontCard({
    required this.cardId,
    required this.name,
    required this.cost,
    required this.properties,
  });
}

typedef BuildingCard = CoalfrontCard<BuildingCardProperties>;
typedef SpellCard = CoalfrontCard<SpellCardProperties>;

/// sealed
abstract class CoalfrontCardTypeProperties {}

class BuildingCardProperties extends CoalfrontCardTypeProperties {
  CoalfrontResourceBundle turnCost;
  CoalfrontResourceBundle turnEarning;
  BuildingCardProperties({
    required this.turnCost,
    required this.turnEarning,
  });
}

class SpellCardProperties extends CoalfrontCardTypeProperties {
  // effect todo
}
