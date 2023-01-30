import 'package:coalfront_logic_2/src/models/game_state/ingame/coalfront_resource.dart';

class CoalfrontResourceBundle {
  Map<CoalfrontResource, int> resources;

  CoalfrontResourceBundle({
    int? wood,
    int? people,
    int? food,
    int? wool,
    int? stone,
    int? coal,
    int? gold,
  }) : resources = {
          CoalfrontResource.wood: wood ?? 0,
          CoalfrontResource.people: people ?? 0,
          CoalfrontResource.food: food ?? 0,
          CoalfrontResource.wool: wool ?? 0,
          CoalfrontResource.stone: stone ?? 0,
          CoalfrontResource.coal: coal ?? 0,
          CoalfrontResource.gold: gold ?? 0,
        };

  int operator [](CoalfrontResource index) => resources[index]!;

  factory CoalfrontResourceBundle.initialFromJustBaseBuilding() =>
      CoalfrontResourceBundle(people: 3, wood: 3, food: 3, wool: 2);
}
