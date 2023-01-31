import 'package:coalfront_logic_2/src/models/game_state/library_state.dart';

class LibraryStateView {
  int cardsLeft;
  int hapsLeft;
  LibraryStateView({
    required this.cardsLeft,
    required this.hapsLeft,
  });

  LibraryStateView.fromState(LibraryState libraryState)
      : cardsLeft = libraryState.cards.length,
        hapsLeft = libraryState.haps.length;
}
