import '../../common/ids.dart';
import 'coalfront_card.dart';

class CoalfrontCardInstance<C extends CoalfrontCardTypeProperties> {
  CardInstanceId cardInstanceId;
  CoalfrontCard<C> card;
  CoalfrontCardInstance({required this.cardInstanceId, required this.card});
}

typedef BuildingCardInstance = CoalfrontCardInstance<BuildingCardProperties>;
typedef SpellCardInstance = CoalfrontCardInstance<SpellCardProperties>;
