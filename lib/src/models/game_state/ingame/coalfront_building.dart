import '../../common/ids.dart';
import '../../common/int2.dart';
import 'coalfront_card_instance.dart';

class CoalfrontBuilding {
  BuildingId buildingId;
  List<Int2> positions;
  CoalfrontBuildingType buildingType;
  CoalfrontBuilding({
    required this.buildingId,
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
  CoalfrontCardInstance cardInstance;
  bool isActive;
  @override
  int viewRange;
  CoalfrontCardBuilding({
    required this.owner,
    required this.cardInstance,
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
