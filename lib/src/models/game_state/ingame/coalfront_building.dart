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
abstract class CoalfrontBuildingType {}

class CoalfrontCardBuilding extends CoalfrontBuildingType {
  UserId userId;
  CoalfrontCardInstance cardInstance;
  bool isActive;
  CoalfrontCardBuilding({
    required this.userId,
    required this.cardInstance,
    this.isActive = true,
  });
}

/// the players initial base
class CoalfrontBaseBuilding extends CoalfrontBuildingType {
  UserId userId;
  CoalfrontBaseBuilding({
    required this.userId,
  });
}
