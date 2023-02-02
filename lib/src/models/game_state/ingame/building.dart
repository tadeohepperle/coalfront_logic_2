import 'package:coalfront_logic_2/src/models/game_state/game_state.dart';
import 'package:coalfront_logic_2/src/models/game_state/indexable_resource.dart';

import '../../common/ids.dart';
import '../../common/int2.dart';

class Building extends IndexableResource<BuildingId> {
  @override
  BuildingId id;
  List<Int2> positions;
  BuildingType buildingType;
  Building({
    required this.id,
    required this.positions,
    required this.buildingType,
  });
}

/// sealed
abstract class BuildingType {
  int get viewRange;
  UserId? get owner;
}

class CardBuilding extends BuildingType {
  @override
  UserId owner;
  CardInstanceId cardInstanceId;
  bool isActive;
  @override
  int viewRange;
  CardBuilding({
    required this.owner,
    required this.cardInstanceId,
    this.isActive = true,
    this.viewRange = 3,
  });
}

/// the players initial base
class BaseBuilding extends BuildingType {
  @override
  int get viewRange => 5;
  @override
  UserId owner;
  BaseBuilding({
    required this.owner,
  });
}
