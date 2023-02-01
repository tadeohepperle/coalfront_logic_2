import 'package:coalfront_logic_2/src/models/game_state/library_state.dart';

class LibraryStateView {
  int cardsLeft;
  LibraryStateView({required this.cardsLeft});

  LibraryStateView.fromLibraryState(LibraryState libraryState)
      : cardsLeft = libraryState.cardInstanceIds.length;
}
