import 'package:coalfront_logic_2/src/models/game_state/ingame/ingame_resource.dart';

class IngameResourceBundle {
  Map<IngameResource, int> _resources;

  IngameResourceBundle({
    int? wood,
    int? people,
    int? food,
    int? wool,
    int? stone,
    int? coal,
    int? gold,
  }) : _resources = {
          IngameResource.wood: wood ?? 0,
          IngameResource.people: people ?? 0,
          IngameResource.food: food ?? 0,
          IngameResource.wool: wool ?? 0,
          IngameResource.stone: stone ?? 0,
          IngameResource.coal: coal ?? 0,
          IngameResource.gold: gold ?? 0,
        };

  int operator [](IngameResource index) => _resources[index]!;

  void operator []=(IngameResource index, int value) =>
      _resources[index] = value;

  bool contains(IngameResourceBundle other) =>
      IngameResource.values.every((v) => this[v] >= other[v]);

  IngameResourceBundle operator +(IngameResourceBundle other) {
    final result = IngameResourceBundle();
    for (final v in IngameResource.values) {
      result[v] = this[v] + other[v];
    }
    return result;
  }

  IngameResourceBundle operator -(IngameResourceBundle other) {
    final result = IngameResourceBundle();
    for (final v in IngameResource.values) {
      result[v] = this[v] - other[v];
    }
    return result;
  }
}
