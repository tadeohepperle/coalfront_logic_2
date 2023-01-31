import '../common/ids.dart';

/// sealed
abstract class GamePhase {}

/// waiting for all players to join
class BeginningPhase extends GamePhase {}

/// where all gameplay happens
class RunningPhase extends GamePhase {
  final TurnPhase turnPhase;

  RunningPhase(this.turnPhase);

  factory RunningPhase.initial() => RunningPhase(TurnPhase.initial());
}

/// where the game is over and a winner is determined
class OverPhase extends GamePhase {
  final UserId winner;
  final int turn;
  OverPhase({
    required this.winner,
    required this.turn,
  });
}

/// sealed
abstract class TurnPhase {
  static TurnPhase initial() => EventPhase();
}

/// todo: add event card
class EventPhase extends TurnPhase {}

class DraftPhase extends TurnPhase {
  Map<UserId, List<CardInstanceId>> pickOptions;
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

/// used to deactivate buildings the player cannot afford anymore.
class EndPhase extends TurnPhase {}
/// todo: keep track in this phase who has still open dept to settle, needs to decomisson buildings
