import 'package:coalfront_logic_2/src/models/game_state/game_phase.dart';

import '../common/ids.dart';
import '../game_state/ingame/coalfront_card_instance.dart';

/// sealed
abstract class GamePhaseView {
  static GamePhaseView fromGamePhase(GamePhase gamePhase, UserId userId) {
    /// dart3 switch pattern
    if (gamePhase is BeginningPhase) {
      return BeginningPhaseView();
    } else if (gamePhase is RunningPhase) {
      final turnPhase = gamePhase.turnPhase;

      /// dart3 switch pattern
      if (turnPhase is EventPhase) {
        return RunningPhaseView(EventPhaseView());
      } else if (turnPhase is DraftPhase) {
        final pickOptions = turnPhase.pickOptions[userId]!;
        final pickMade = turnPhase.picksMade[userId];
        return RunningPhaseView(
            DraftPhaseView(pickOptions: pickOptions, pickMade: pickMade));
      } else if (turnPhase is PlayPhase) {
        return RunningPhaseView(PlayPhaseView(
          activePlayer: turnPhase.activePlayer,
          playOrder: turnPhase.playOrder,
        ));
      } else if (turnPhase is EndPhase) {
        return RunningPhaseView(EndPhaseView());
      }
    } else if (gamePhase is OverPhase) {
      return OverPhaseView(winner: gamePhase.winner, turn: gamePhase.turn);
    }
    throw "dart3 exhaustive check makes this throw unnessecary";
  }
}

/// waiting for all players to join
class BeginningPhaseView extends GamePhaseView {}

/// where all gameplay happens
class RunningPhaseView extends GamePhaseView {
  final TurnPhaseView turnPhaseView;

  RunningPhaseView(this.turnPhaseView);
}

/// where the game is over and a winner is determined
class OverPhaseView extends GamePhaseView {
  final UserId winner;
  final int turn;
  OverPhaseView({
    required this.winner,
    required this.turn,
  });
}

/// sealed
abstract class TurnPhaseView {}

class EventPhaseView extends TurnPhaseView {}

class DraftPhaseView extends TurnPhaseView {
  List<CoalfrontCardInstance> pickOptions;
  CardInstanceId? pickMade;
  DraftPhaseView({
    required this.pickOptions,
    required this.pickMade,
  });
}

class PlayPhaseView extends TurnPhaseView {
  List<UserId> playOrder;
  UserId activePlayer;
  PlayPhaseView({
    required this.playOrder,
    required this.activePlayer,
  });
}

class EndPhaseView extends TurnPhaseView {}
