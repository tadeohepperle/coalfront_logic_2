import 'package:coalfront_logic_2/src/constants.dart';
import 'package:coalfront_logic_2/src/models/common/game_creation_config.dart';
import 'package:coalfront_logic_2/src/models/common/user.dart';
import 'package:coalfront_logic_2/src/models/game_state/i_resources_index.dart';
import 'package:coalfront_logic_2/src/models/game_state/indexable_resource.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/building.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/card.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/card_instance.dart';
import 'package:coalfront_logic_2/src/models/game_state/player_state.dart';
import 'package:coalfront_logic_2/src/models/game_state/session_state.dart';
import 'package:dartz/dartz.dart';

import '../common/ids.dart';
import 'functions/functions.dart';
import 'game_phase.dart';
import 'id_index_structure.dart';
import 'ingame/ingame_resource_bundle.dart';
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
    final indexStructure =
        TestIndexStructure.testIndexFromConfigAndMap(config, mapState);
    final libraryState = LibraryState.testDecks(indexStructure);
    final gameState = GameState(
      gameId: gameId,
      gamePhase: gamePhase,
      mapState: mapState,
      sessionState: sessionState,
      playerStates: playerStates,
      libraryState: libraryState,
      indexStructure: indexStructure,
    );

    // set initial player buildings:

    final basePositions =
        generatePlayerBasePositions(config.players.length, config.mapSize);
    for (var i = 0; i < config.players.length; i++) {
      final player = config.players[i];
      final baseBuilding = Building(
        id: generateUniqueId(),
        positions: basePositions[i],
        buildingType: BaseBuilding(owner: player.id),
      );

      gameState.registerBuilding(baseBuilding);
    }

    return gameState;
  }

  void registerBuilding(Building building) {
    if (tryResolve<Building, BuildingId>(building.id) != null) {
      throw Exception("Already building registered under id ${building.id}");
    }
    insert(building);
    mapState.setOccuppied(building.positions, building.id);
    // recalculate player earnings if necessary
    final owner = building.buildingType.owner;
    if (owner != null) {
      final netProduction = netProductionOfBuilding(building, indexStructure);
      playerStates[owner].netProduction += netProduction;
    }
  }

  void deregisterBuilding(Building building) {
    if (tryResolve<Building, BuildingId>(building.id) == null) {
      throw Exception("Building not registered under id ${building.id}");
    }
    remove<Building, BuildingId>(building.id);
    mapState.setUnoccupied(building.positions);
    // recalculate player netProduction if necessary
    final owner = building.buildingType.owner;
    if (owner != null) {
      final netProduction = netProductionOfBuilding(building, indexStructure);
      playerStates[owner].netProduction -= netProduction;
    }
  }

  @override
  T resolve<T extends IndexableResource<N>, N>(N id) =>
      indexStructure.resolve<T, N>(id);

  @override
  T? tryResolve<T extends IndexableResource<N>, N>(N id) =>
      indexStructure.tryResolve<T, N>(id);

  @override
  void insert<T extends IndexableResource<N>, N>(T item) =>
      indexStructure.insert<T, N>(item);

  @override
  void remove<T extends IndexableResource<N>, N>(N id) =>
      indexStructure.remove<T, N>(id);

  ////////////////////////////////////////////////////////////////////////////////
  // Helper functions
  ////////////////////////////////////////////////////////////////////////////////

  /// Production - Consumption
}
