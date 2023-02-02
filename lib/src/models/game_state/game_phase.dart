import 'dart:convert';

import 'package:collection/collection.dart';

import '../common/ids.dart';

/// sealed
abstract class GamePhase {}

/// waiting for all players to join
class BeginningPhase extends GamePhase {}

/// where all gameplay happens
class RunningPhase extends GamePhase {
  final int turn;
  final TurnPhase turnPhase;

  RunningPhase(
    this.turn,
    this.turnPhase,
  );

  RunningPhase copyWith({
    int? turn,
    TurnPhase? turnPhase,
  }) {
    return RunningPhase(
      turn ?? this.turn,
      turnPhase ?? this.turnPhase,
    );
  }

  @override
  String toString() => 'RunningPhase(turn: $turn, turnPhase: $turnPhase)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RunningPhase &&
        other.turn == turn &&
        other.turnPhase == turnPhase;
  }

  @override
  int get hashCode => turn.hashCode ^ turnPhase.hashCode;
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
  List<UserId> get playOrder;
}

// future: out of scope, add event cards
// class EventPhase extends TurnPhase {}

class DraftPhase extends TurnPhase {
  @override
  final List<UserId> playOrder;
  final int finalTotalRounds;
  final List<DraftRound> draftRounds;
  DraftPhase({
    required this.playOrder,
    required this.finalTotalRounds,
    required this.draftRounds,
  });
}

class DraftRound {
  final int
      roundNumber; // 1 = first round with 3 cards, 2 = seconds round with 2 cards, ...
  Map<UserId, List<CardInstanceId>> pickOptions;
  Map<UserId, CardInstanceId> picksMade;
  DraftRound({
    required this.roundNumber,
    required this.pickOptions,
    required this.picksMade,
  });
}

class PlayPhase extends TurnPhase {
  @override
  final List<UserId> playOrder; // exhaustive
  UserId activePlayer;
  Map<UserId, int> passedCount; // exhaustive
  List<UserId> endedTurn;

  PlayPhase({
    required this.playOrder,
    required this.activePlayer,
    required this.passedCount,
    required this.endedTurn,
  });

  factory PlayPhase.fromPlayOrder(List<UserId> playOrder) {
    return PlayPhase(
      playOrder: playOrder,
      activePlayer: playOrder[0],
      passedCount: {for (var i in playOrder) i: 0},
      endedTurn: [],
    );
  }

  PlayPhase copyWith({
    List<UserId>? playOrder,
    UserId? activePlayer,
    Map<UserId, int>? passedCount,
    List<UserId>? endedTurn,
  }) {
    return PlayPhase(
      playOrder: playOrder ?? this.playOrder,
      activePlayer: activePlayer ?? this.activePlayer,
      passedCount: passedCount ?? this.passedCount,
      endedTurn: endedTurn ?? this.endedTurn,
    );
  }
}

/// used to deactivate buildings the player cannot afford anymore.
class EndPhase extends TurnPhase {
  @override
  final List<UserId> playOrder;

  EndPhase(this.playOrder);
}
/// todo: keep track in this phase who has still open dept to settle, needs to decomisson buildings
