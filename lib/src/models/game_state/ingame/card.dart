import 'package:coalfront_logic_2/src/models/game_state/indexable_resource.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/ingame_resource_bundle.dart';

import '../../common/ids.dart';

class Card<C extends CoalfrontCardTypeProperties>
    implements IndexableResource<CardId> {
  @override
  CardId id;
  String name;
  IngameResourceBundle cost;
  C properties;
  Card({
    required this.id,
    required this.name,
    required this.cost,
    required this.properties,
  });
}

typedef BuildingCard = Card<BuildingCardProperties>;
typedef SpellCard = Card<SpellCardProperties>;

/// sealed
abstract class CoalfrontCardTypeProperties {}

class BuildingCardProperties extends CoalfrontCardTypeProperties {
  IngameResourceBundle turnCost;
  IngameResourceBundle turnEarning;
  BuildingCardProperties({
    required this.turnCost,
    required this.turnEarning,
  });
}

class SpellCardProperties extends CoalfrontCardTypeProperties {
  // effect todo
}
