import 'package:coalfront_logic_2/src/models/game_state/indexable_resource.dart';

import '../../common/ids.dart';
import '../../common/int2.dart';
import 'card_instance.dart';

class Building extends IndexableResource<BuildingId> {
  @override
  BuildingId id;
  List<Int2> positions;
  CoalfrontBuildingType buildingType;
  Building({
    required this.id,
    required this.positions,
    required this.buildingType,
  });
}

/// sealed
abstract class CoalfrontBuildingType {
  int get viewRange;
  UserId? get owner;
}

class CoalfrontCardBuilding extends CoalfrontBuildingType {
  @override
  UserId owner;
  CardInstanceId cardInstanceId;
  bool isActive;
  @override
  int viewRange;
  CoalfrontCardBuilding({
    required this.owner,
    required this.cardInstanceId,
    this.isActive = true,
    this.viewRange = 3,
  });
}

/// the players initial base
class CoalfrontBaseBuilding extends CoalfrontBuildingType {
  @override
  int get viewRange => 5;
  @override
  UserId owner;
  CoalfrontBaseBuilding({
    required this.owner,
  });
}
