import 'package:coalfront_logic_2/src/models/common/user.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_state.dart';
import 'package:coalfront_logic_2/src/models/player_actions/i_viewable.dart';
import 'package:dartz/dartz.dart';

import '../common/ids.dart';
import 'ingame/coalfront_card_instance.dart';

/// sealed
abstract class GamePhase implements IViewable<GamePhaseView, Unit> {}

/// waiting for all players to join
class BeginningPhase extends GamePhase {
  @override
  GamePhaseView getView(GameStateUnmodifyable gameState, User user) =>
      BeginningPhaseView();
}

/// where all gameplay happens
class RunningPhase extends GamePhase {
  final TurnPhase turnPhase;

  RunningPhase(this.turnPhase);

  @override
  GamePhaseView getView(GameStateUnmodifyable gameState, User user) =>
      RunningPhaseView(turnPhase.getView(gameState, user));
}

/// where the game is over and a winner is determined
class OverPhase extends GamePhase {
  final User winner;
  final int turn;
  OverPhase({
    required this.winner,
    required this.turn,
  });
  
  @override
  GamePhaseView getView(GameStateUnmodifyable gameState, User user) => OverPhaseView(winner: winner, turn: turn)
}


/// sealed
abstract class TurnPhase implements IViewable<TurnPhaseView, Unit> {}

class EventPhase extends TurnPhase {
  @override
  TurnPhaseView getView(GameStateUnmodifyable gameState, User user) => 
}

class DraftPhase extends TurnPhase {
  Map<UserId, List<CoalfrontCardInstance>> pickOptions;
  Map<UserId, CardInstanceId> picksMade;
  DraftPhase({
    required this.pickOptions,
    required this.picksMade,
  });
}

class PlayPhase extends TurnPhase {
  List<UserId> playOrder;
  UserId activePlayer;
  PlayPhase({
    required this.playOrder,
    required this.activePlayer,
  });
}

class EndPhase extends TurnPhase {}

////////////////////////////////////////////////////////////////////////////////
/// Views
////////////////////////////////////////////////////////////////////////////////

/// sealed
abstract class GamePhaseView extends PublicView<Unit> {}

/// waiting for all players to join
class BeginningPhaseView extends GamePhaseView {}

/// where all gameplay happens
class RunningPhaseView extends GamePhaseView {
  final TurnPhaseView turnPhaseView;
  RunningPhaseView(this.turnPhaseView);
}

/// where the game is over and a winner is determined
class OverPhaseView extends GamePhaseView {
  final User winner;
  final int turn;
  OverPhaseView({
    required this.winner,
    required this.turn,
  });
}

/// sealed
abstract class TurnPhaseView extends PublicView<Unit>{}

class EventPhaseView extends TurnPhaseView {}

class DraftPhaseView extends TurnPhaseView {
  Map<UserId, List<CoalfrontCardInstance>> pickOptions;
  Map<UserId, CardInstanceId> picksMade;
  DraftPhaseView({
    required this.pickOptions,
    required this.picksMade,
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
