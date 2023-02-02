import 'package:coalfront_logic_2/src/models/game_state/indexable_resource.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/ingame_resource_bundle.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/tile_type.dart';

import '../../common/ids.dart';
import '../../common/int2.dart';

class Card<C extends CardTypeProperties> implements IndexableResource<CardId> {
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
abstract class CardTypeProperties {}

class BuildingCardProperties extends CardTypeProperties {
  /// production - consumption
  IngameResourceBundle netProduction;
  List<TileType> suitableTiles;
  List<Int2> relativePositions;
  BuildingCardProperties({
    required this.netProduction,
    required this.suitableTiles,
    this.relativePositions = const [Int2(0, 0)],
  });
}

class SpellCardProperties extends CardTypeProperties {
  // effect todo
}
