import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_state/id_index_structure.dart';

class LibraryState {
  List<CardInstanceId> _cardInstanceIds; // card deck (for player draws)
  Iterable<CardInstanceId> get cardInstanceIds => _cardInstanceIds;

  // List<HapInstanceId> hapInstanceIds; // event deck
  LibraryState({
    required List<CardInstanceId> cardInstanceIds,
    // required this.hapInstanceIds,
  }) : _cardInstanceIds = cardInstanceIds;

  /// todo: this is just test
  factory LibraryState.testDecks(IdIndexStructure indexStructure) {
    // final hapInstanceIds = indexStructure.hapInstanceIds.toList();
    // hapInstanceIds.shuffle();

    final cardInstanceIds = indexStructure.cardInstanceIds.toList();
    cardInstanceIds.shuffle();

    return LibraryState(
      cardInstanceIds: cardInstanceIds,
      // hapInstanceIds: hapInstanceIds,
    );
  }

  /// removes top k cards from library and returns them. Mutating!!!
  List<CardInstanceId> popTop(int k) => _cardInstanceIds.popTop(k);

  int get cardCount => _cardInstanceIds.length;
}

extension PopTop<T> on List<T> {
  /// mutates the list!
  List<T> popTop(int k) {
    if (k > length) {
      throw Exception("cannot pop top $k from List<$T> of $length elements.");
    }
    final results = sublist(length - k, length);
    removeRange(length - k, length);
    return results;
  }
}
