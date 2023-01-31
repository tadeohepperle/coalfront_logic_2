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
/// Join
////////////////////////////////////////////////////////////////////////////////

/// dart3 sealed
abstract class JoinFailure extends PlayerActionFailure {}

class JoinFailureAlreadyInSession extends JoinFailure {}

class JoinFailureNotPartOfThisGame extends JoinFailure {}

////////////////////////////////////////////////////////////////////////////////
/// Leave
////////////////////////////////////////////////////////////////////////////////

/// dart3 sealed
abstract class LeaveFailure extends PlayerActionFailure {}

class LeaveFailureWasNotJoined extends LeaveFailure {}

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

////////////////////////////////////////////////////////////////////////////////
/// PassTurn
////////////////////////////////////////////////////////////////////////////////

/// dart3 sealed
abstract class PassTurnFailure extends PlayerActionFailure {}

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

abstract class BuildBuildingFailureCannotPayCost extends BuildBuildingFailure {}

abstract class BuildBuildingFailureSpaceOccupied extends BuildBuildingFailure {}

/// dart3 sealed
abstract class CastSpellFailure extends MakePlayFailure {}

abstract class CastSpellFailureCannotPayCost extends CastSpellFailure {}

abstract class CastSpellFailureInvalidTargets extends CastSpellFailure {}
