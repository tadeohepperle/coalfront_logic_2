import '../../common/ids.dart';
import 'coalfront_cost.dart';

class CoalfrontCard {
  CardId cardId;
  String name;
  CoalfrontCost cost;
  CoalfrontCard({
    required this.cardId,
    required this.name,
    required this.cost,
  });
}

/// sealed
abstract class CoalfrontCardtype {}

class BuildingCard extends CoalfrontCardtype {
  CoalfrontCost turnCost;
  CoalfrontCost turnEarning;
  BuildingCard({
    required this.turnCost,
    required this.turnEarning,
  });
}

class SpellCard extends CoalfrontCardtype {}
