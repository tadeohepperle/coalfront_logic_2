import '../../common/ids.dart';
import '../indexable_resource.dart';
import 'card.dart';

class CardInstance<C extends CoalfrontCardTypeProperties>
    implements IndexableResource<CardInstanceId> {
  @override
  CardInstanceId id;
  Card<C> card;
  CardInstance({required this.id, required this.card});
}

typedef BuildingCardInstance = CardInstance<BuildingCardProperties>;
typedef SpellCardInstance = CardInstance<SpellCardProperties>;
