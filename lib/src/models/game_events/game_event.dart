import 'package:coalfront_logic_2/src/models/common/ids.dart';

import 'game_phase_view.dart';

/// sealed
abstract class GameEvent {}

////////////////////////////////////////////////////////////////////////////////
/// Join
////////////////////////////////////////////////////////////////////////////////

/// sent to player who joined

/// see class JoinInitialDataLoad in separate file

/// sent to all other players to notify them that the player joined
class PlayerJoined extends GameEvent {
  /// Usecase: the join leads to the start of the game because it is the last missing join.
  GamePhaseView gamePhaseView;
  UserId userId;
  PlayerJoined({
    required this.gamePhaseView,
    required this.userId,
  });
}

////////////////////////////////////////////////////////////////////////////////
/// Leave
////////////////////////////////////////////////////////////////////////////////

/// sent to all other players to notify them that the player left
class PlayerLeft {
  UserId userId;
  PlayerLeft({
    required this.userId,
  });
}

////////////////////////////////////////////////////////////////////////////////
/// EndGame
////////////////////////////////////////////////////////////////////////////////

/// when the owner ends/deletes the game. Sent to all other players to notify them.
class GameWasEnded {}

////////////////////////////////////////////////////////////////////////////////
/// DraftPick
////////////////////////////////////////////////////////////////////////////////

/// sent to all players
class DraftPickDone {
  /// Usecase: the players get notified who has done their picks yet / the last pick leads to transition to PlayPhase
  GamePhaseView gamePhaseView;
  UserId userId;
  DraftPickDone({
    required this.gamePhaseView,
    required this.userId,
  });
}
