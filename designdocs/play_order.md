DraftPhase:
- players all make picks at the same time.

PlayPhase: 
- the Playphase consists of n turns in the range of [numPlayers,infinite), where n is not clear until the Playphase has ended.
- in each turn there is exactly one active player. He can choose one of the following.
  - MakePlay (buildBuilding, CastSpell, Activated Ability)
  - PassTurn (endGame = false)
  - PassTurn (endGame = true) also referred to as EndTurn 
- random PlayOrder  (design todo, future: maybe sorted after winPoints)
- the first player in playorder gets initiative first and can either make a play or pass or end the turn for them
- after that, it's the next players turn and then next, until infinity (looping around). Players who ended the turn are always skipped.
- there is a `Map<UserId,int>` for each player counting consecutive passes. 
- the int can be { 0, 1, 2, ... }
- A player ending their turn gets this value set to Infinity (or 10000).
- After a player passes their turn SkippedTurns gets increased.
- If a player makes a play their SkippedTurns value is reset to 0.
- if after a player passed or ended their turn and then every player has a SkippedTurns value of 2 or greater, the PlayPhase is ended.
