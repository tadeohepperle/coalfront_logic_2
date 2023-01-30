/// sealed class
abstract class PlayerActionFailure {}

class UnknownFailure extends PlayerActionFailure {
  String? message;
  UnknownFailure([this.message]);
}

/// sealed class
abstract class JoinFailure extends PlayerActionFailure {}

class JoinFailureAlreadyInSession extends JoinFailure {}

class JoinFailureNotPartOfThisGame extends JoinFailure {}

/// sealed class
abstract class LeaveFailure extends PlayerActionFailure {}

class LeaveFailureWasNotJoined extends LeaveFailure {}

/// sealead class

abstract class DraftPickFailure extends PlayerActionFailure {}

class DraftPickFailureCardNotInPicks extends DraftPickFailure {}
