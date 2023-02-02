/// A PlayerActionFailure should be a very rare case!
/// Usually the UI should already prevent the players from submitting actions that would lead to failures.
/// So we should playtest until zero of these Failures are logged!!!
/// dart3 sealed
abstract class PlayerActionFailure {}

class UnknownFailure extends PlayerActionFailure {
  String? message;
  UnknownFailure([this.message]);
}

////////////////////////////////////////////////////////////////////////////////
// Generic
////////////////////////////////////////////////////////////////////////////////

/// only players that are part of the game can send in any actions
class PlayerActionFailureNotPartOfThisGame extends PlayerActionFailure {}

class PlayerActionFailureWasNotJoined extends PlayerActionFailure {}

class PlayerActionFailureWrongPhase extends PlayerActionFailure
    implements DraftPickFailure, MakePlayFailure, PassTurnFailure {}

////////////////////////////////////////////////////////////////////////////////
/// Join
////////////////////////////////////////////////////////////////////////////////

/// dart3 sealed
abstract class JoinFailure extends PlayerActionFailure {}

class JoinFailureAlreadyInSession extends JoinFailure {}

////////////////////////////////////////////////////////////////////////////////
/// Leave
////////////////////////////////////////////////////////////////////////////////

/// dart3 sealed
abstract class LeaveFailure extends PlayerActionFailure {}

////////////////////////////////////////////////////////////////////////////////
/// EndGame
////////////////////////////////////////////////////////////////////////////////

/// dart3 sealed
abstract class EndGameFailure extends PlayerActionFailure {}

class EndGameFailureNotTheOwner extends EndGameFailure {}

////////////////////////////////////////////////////////////////////////////////
/// DraftPick
////////////////////////////////////////////////////////////////////////////////

/// dart3 sealed
abstract class DraftPickFailure extends PlayerActionFailure {}

class DraftPickFailureCardNotInPicks extends DraftPickFailure {}

class DraftPickFailurePickAlreadyMade extends DraftPickFailure {}

////////////////////////////////////////////////////////////////////////////////
/// PassTurn
////////////////////////////////////////////////////////////////////////////////

/// dart3 sealed
abstract class PassTurnFailure extends PlayerActionFailure {}

class PlayerActionFailureAlreadyEndedTurn extends PlayerActionFailure
    implements PassTurnFailure, MakePlayFailure {}

class PlayerActionFailureNotPlayersTurn extends PlayerActionFailure
    implements PassTurnFailure, MakePlayFailure {}

/// it should be possible to pass the turn even if it's not your go right now??
/// Is premoved for when it's your turn???
/// Or should this be handles clientside, by sending
/// the premoved action only to the server when getting the go from the server to move??
/// (this option is probably easier and less confusing)
class PassTurnFailureNotInPlayPhase extends PassTurnFailure {}

////////////////////////////////////////////////////////////////////////////////
/// MakePlay
////////////////////////////////////////////////////////////////////////////////

/// dart3 sealed
abstract class MakePlayFailure extends PlayerActionFailure {}

/// dart3 sealed
abstract class BuildBuildingFailure extends MakePlayFailure {}

class BuildBuildingFailureCannotPayCost extends BuildBuildingFailure {}

class BuildBuildingFailureSpaceOccupied extends BuildBuildingFailure {}

// Building Ids are created on the client and sent to the server
class BuildBuildingFailureIdCollision extends BuildBuildingFailure {}

/// dart3 sealed
abstract class CastSpellFailure extends MakePlayFailure {}

class CastSpellFailureCannotPayCost extends CastSpellFailure {}

class CastSpellFailureInvalidTargets extends CastSpellFailure {}
