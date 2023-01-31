import 'package:coalfront_logic_2/src/models/game_state/ingame/ingame_resource.dart';

class IngameResourceBundle {
  Map<IngameResource, int> resources;

  IngameResourceBundle({
    int? wood,
    int? people,
    int? food,
    int? wool,
    int? stone,
    int? coal,
    int? gold,
  }) : resources = {
          IngameResource.wood: wood ?? 0,
          IngameResource.people: people ?? 0,
          IngameResource.food: food ?? 0,
          IngameResource.wool: wool ?? 0,
          IngameResource.stone: stone ?? 0,
          IngameResource.coal: coal ?? 0,
          IngameResource.gold: gold ?? 0,
        };

  int operator [](IngameResource index) => resources[index]!;

  factory IngameResourceBundle.initialFromJustBaseBuilding() =>
      IngameResourceBundle(people: 3, wood: 3, food: 3, wool: 2);
}
