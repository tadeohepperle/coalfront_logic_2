import 'package:coalfront_logic_2/src/models/common/game_creation_config.dart';
import 'package:coalfront_logic_2/src/models/common/user.dart';
import 'package:coalfront_logic_2/src/models/game_state/i_resources_index.dart';
import 'package:coalfront_logic_2/src/models/game_state/indexable_resource.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/building.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/card.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/card_instance.dart';
import 'package:coalfront_logic_2/src/models/game_state/player_state.dart';
import 'package:coalfront_logic_2/src/models/game_state/session_state.dart';

import '../common/ids.dart';
import 'game_phase.dart';
import 'id_index_structure.dart';
import 'library_state.dart';
import 'map_state.dart';

/// todo: how is the library read in??? player decks??

class GameState implements IResourcesIndex {
  final GameId gameId;
  GamePhase gamePhase;
  final MapState mapState;
  final SessionState sessionState;
  final PlayerStates playerStates;
  final LibraryState libraryState;
  final IdIndexStructure indexStructure;
  GameState({
    required this.gameId,
    required this.gamePhase,
    required this.mapState,
    required this.sessionState,
    required this.playerStates,
    required this.libraryState,
    required this.indexStructure,
  });

  factory GameState.initialFromConfig(GameCreationConfig config) {
    final gamePhase = BeginningPhase();
    final gameId = config.gameId;
    final mapState = MapState.initialFromConfig(config);
    final sessionState = SessionState(
      owner: config.owner,
      playersJoined: [],
    );
    final playerStates = PlayerStates.initialFromConfig(config);
    final indexStructure = IdIndexStructure.testIndexFromConfig(config);
    final libraryState = LibraryState.testDecks(indexStructure);
    return GameState(
      gameId: gameId,
      gamePhase: gamePhase,
      mapState: mapState,
      sessionState: sessionState,
      playerStates: playerStates,
      libraryState: libraryState,
      indexStructure: indexStructure,
    );
  }

  @override
  T resolve<T extends IndexableResource<N>, N>(N id) =>
      indexStructure.resolve(id);
}
