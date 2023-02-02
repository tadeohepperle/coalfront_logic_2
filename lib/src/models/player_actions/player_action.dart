import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/common/int2.dart';
import '../common/rotation_steps.dart';

/// sealed
abstract class PlayerAction {
  UserId get player;
}

class JoinGame extends PlayerAction {
  @override
  UserId player;
  JoinGame({
    required this.player,
  });
}

class LeaveGame extends PlayerAction {
  @override
  UserId player;
  LeaveGame({
    required this.player,
  });
}

class EndGame extends PlayerAction {
  @override
  UserId player;
  EndGame({
    required this.player,
  });
}

class DraftPick extends PlayerAction {
  @override
  UserId player;
  CardInstanceId cardInstanceId;
  DraftPick({
    required this.player,
    required this.cardInstanceId,
  });
}

class PassTurn extends PlayerAction {
  @override
  UserId player;

  /// if endTurn = false the player just passes initiative to the next player, but can play at a later point in this playPhase
  /// if endTurn = true the player has committed to not play anything anymore this turn.
  bool endTurn;
  PassTurn({
    required this.player,
    required this.endTurn,
  });
}

class BuildBuilding extends PlayerAction {
  @override
  UserId player;
  CardInstanceId cardInstanceId;
  Int2 position;
  RotationSteps rotation;
  BuildingId buildingId;
  BuildBuilding({
    required this.player,
    required this.cardInstanceId,
    required this.position,
    required this.rotation,
    required this.buildingId,
  });
}


/// todo: out of scope
// class CastSpell extends PlayerAction {
//   @override
//   UserId player;
//   CardInstanceId cardInstanceId;
//   CastSpell({
//     required this.player,
//     required this.cardInstanceId,
//   });

//   /// todo: targets, etc...
//   ///
// }

/// todo: future: activated abilities
/// class ActivateAbility extends MakePlay
