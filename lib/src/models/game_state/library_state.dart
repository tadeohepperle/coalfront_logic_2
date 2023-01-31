import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_state/id_index_structure.dart';

class LibraryState {
  List<CardInstanceId> cardInstanceIds; // card deck (for player draws)
  List<HapInstanceId> hapInstanceIds; // event deck
  LibraryState({
    required this.cardInstanceIds,
    required this.hapInstanceIds,
  });

  /// todo: this is just test
  factory LibraryState.testDecks(IdIndexStructure indexStructure) {
    final hapInstanceIds = indexStructure.hapInstanceIds.toList();
    hapInstanceIds.shuffle();

    final cardInstanceIds = indexStructure.cardInstanceIds.toList();
    cardInstanceIds.shuffle();

    return LibraryState(
      cardInstanceIds: cardInstanceIds,
      hapInstanceIds: hapInstanceIds,
    );
  }
}
