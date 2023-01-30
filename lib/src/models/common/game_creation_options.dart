import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/common/user.dart';

import 'game_creation_config.dart';
import 'int2.dart';

class GameCreationOptions {
  int? seed;
  int? numPlayers;
  Int2? mapSize;

  GameCreationConfig toConfig(
      {required List<User> players,
      required GameId gameId,
      required UserId owner}) {
    return GameCreationConfig(
      seed: seed ?? 69,
      players: players,
      owner: owner,
      mapSize: mapSize ?? const Int2(20, 20),
      gameId: gameId,
    );
  }
}
