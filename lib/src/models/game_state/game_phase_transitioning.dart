import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_state/functions/functions.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_phase.dart';

extension DraftPhaseTransitions on DraftPhase {
  TurnPhase transitionToPlayPhaseOrNextRound() {
    final goToPlayPhaseLastDraftRoundIsDone =
        draftRounds.length == finalTotalRounds;
    if (goToPlayPhaseLastDraftRoundIsDone) {
      return transitionToPlayPhase();
    } else {
      return transitionToNextRound();
    }
  }

  DraftPhase transitionToNextRound() {
    if (draftRounds.last.picksMade.length <
        draftRounds.last.pickOptions.keys.length) {
      throw Exception(
          "not every player has made the pick yet! Cannot transition to next round");
    }

    DraftRound lastRound = draftRounds.last;
    Map<String, List<CardInstanceId>> nextRoundPickOptions = {};
    for (final player in playOrder) {
      final nextPlayer = playOrder.nextWithLooping(player);
      final playerPick = draftRounds.last.picksMade[player]!;
      final playerPickOptionsCopied = [
        ...draftRounds.last.pickOptions[player]!
      ];
      if (playerPickOptionsCopied.contains(playerPick)) {
        throw Exception(
            "playerPick $playerPick not in players pickOptions: $playerPickOptionsCopied!");
      }
      playerPickOptionsCopied.remove(playerPick);
      nextRoundPickOptions[nextPlayer] = playerPickOptionsCopied;
    }
    DraftRound nextRound = DraftRound(
      roundNumber: lastRound.roundNumber + 1,
      pickOptions: nextRoundPickOptions,
      picksMade: {},
    );

    draftRounds.add(nextRound);
    return this;
  }

  PlayPhase transitionToPlayPhase() => PlayPhase.fromPlayOrder(playOrder);
}

extension PlayPhaseTransitions on PlayPhase {
  EndPhase transitionToEndPhase() => EndPhase(playOrder);
}
