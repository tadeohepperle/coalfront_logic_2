import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/common/user.dart';

import 'int2.dart';

class GameCreationConfig {
  GameId gameId;
  int seed;
  UserId owner;
  List<User> players;
  Int2 mapSize;
  GameCreationConfig({
    required this.gameId,
    required this.seed,
    required this.owner,
    required this.players,
    required this.mapSize,
  });
}
