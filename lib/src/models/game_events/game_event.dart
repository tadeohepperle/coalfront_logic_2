import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/common/int2.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/tile_type.dart';

import '../game_state/ingame/building.dart';
import 'game_phase_view.dart';

/// sealed
abstract class GameEvent {}

/// sent to all other players to notify them that the player joined
class PlayerJoined extends GameEvent {
  GamePhaseView gamePhaseView;
  UserId userId;
  PlayerJoined({
    required this.gamePhaseView,
    required this.userId,
  });
}

/// sent to all other players to notify them that the player left
class PlayerLeft extends GameEvent {
  UserId userId;
  PlayerLeft({
    required this.userId,
  });
}

/// when the owner ends/deletes the game. Sent to all other players to notify them.
class GameWasEnded extends GameEvent {
  /// by this player (owner)
  UserId userId;
  GameWasEnded({
    required this.userId,
  });
}

/// sent to all players
class DraftPickDone extends GameEvent {
  /// Usecase: the players get notified who has done their picks yet / the last pick leads to transition to PlayPhase
  GamePhaseView gamePhaseView;
  UserId userId;
  DraftPickDone({
    required this.gamePhaseView,
    required this.userId,
  });
}

////////////////////////////////////////////////////////////////////////////////
// PlayerPassed
////////////////////////////////////////////////////////////////////////////////

class PlayerPassed extends GameEvent {
  /// Usecase: the players get notified who has done their picks yet / the last pick leads to transition to PlayPhase
  GamePhaseView gamePhaseView;
  UserId userId;
  bool endTurn;
  PlayerPassed({
    required this.gamePhaseView,
    required this.userId,
    required this.endTurn,
  });
}

/// sent to other players that can see the building
class BuiltBuildingVisible extends GameEvent {
  GamePhaseView gamePhaseView;
  UserId userId;
  Building building;
  BuiltBuildingVisible({
    required this.gamePhaseView,
    required this.userId,
    required this.building,
  });
}

/// sent to other players that cannot see the building
class BuiltBuildingInvisible extends GameEvent {
  GamePhaseView gamePhaseView;
  UserId userId;
  BuiltBuildingInvisible({
    required this.gamePhaseView,
    required this.userId,
  });
}

/// sent to player who built the building
class BuiltBuildingMapUpdate extends GameEvent {
  GamePhaseView gamePhaseView;
  Map<Int2, TileType> updatedTiles;
  BuiltBuildingMapUpdate({
    required this.gamePhaseView,
    required this.updatedTiles,
  });
}
