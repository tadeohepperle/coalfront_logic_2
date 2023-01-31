import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/common/int2.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/coalfront_card.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/coalfront_card_instance.dart';

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
  PassTurn({
    required this.player,
  });
}

/// sealed
abstract class MakePlay extends PlayerAction {}

class BuildBuilding extends MakePlay {
  @override
  UserId player;
  BuildingCardInstance cardInstance;
  Int2 position;
  RotationSteps totation;
  BuildBuilding({
    required this.player,
    required this.cardInstance,
    required this.position,
    required this.totation,
  });
}

class CastSpell extends MakePlay {
  @override
  UserId player;
  SpellCardInstance cardInstance;
  CastSpell({
    required this.player,
    required this.cardInstance,
  });

  /// todo: targets, etc...
  ///
}

/// todo: future: activated abilities
/// class ActivateAbility extends MakePlay
