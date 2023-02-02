import 'package:coalfront_logic_2/src/models/common/game_creation_config.dart';
import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/common/int2.dart';
import 'package:coalfront_logic_2/src/models/game_state/i_resources_index.dart';
import 'package:coalfront_logic_2/src/models/game_state/indexable_resource.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/card.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/card_instance.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/hap.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/hap_instance.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/ingame_resource_bundle.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/tile_type.dart';
import 'package:coalfront_logic_2/src/models/game_state/map_state.dart';
import 'package:coalfront_logic_2/src/models/game_state/player_state.dart';

import '../common/user.dart';
import 'functions/functions.dart';
import 'ingame/building.dart';

class IdIndexStructure implements IResourcesIndex {
  // future: out of scope
  // final Map<HapId, Hap> _haps;
  // final Map<HapInstanceId, HapInstance> _hapInstances;
  final Map<CardId, Card> _cards;
  final Map<CardInstanceId, CardInstance> _cardInstances;
  final Map<BuildingId, Building> _buildings;
  final Map<UserId, User> _users;

  // future: out of scope
  // Iterable<Hap> get haps => _haps.values;
  // Iterable<HapId> get hapIds => _haps.keys;
  // Iterable<HapInstance> get hapInstances => _hapInstances.values;
  // Iterable<HapInstanceId> get hapInstanceIds => _hapInstances.keys;
  Iterable<Card> get cards => _cards.values;
  Iterable<CardId> get cardIds => _cards.keys;
  Iterable<CardInstance> get cardInstances => _cardInstances.values;
  Iterable<CardInstanceId> get cardInstanceIds => _cardInstances.keys;
  Iterable<Building> get buildings => _buildings.values;
  Iterable<BuildingId> get buildingIds => _buildings.keys;
  Iterable<User> get users => _users.values;
  Iterable<UserId> get userIds => _users.keys;

  IdIndexStructure({
    required Map<CardId, Card> cards,
    required Map<CardInstanceId, CardInstance> cardInstances,
    required Map<BuildingId, Building> buildings,
    required Map<UserId, User> users,
  })  : _cards = cards,
        _cardInstances = cardInstances,
        _buildings = buildings,
        _users = users;

  static IdIndexStructure from(IdIndexStructure other) {
    return IdIndexStructure(
      cards: Map.from(other._cards),
      cardInstances: Map.from(other._cardInstances),
      buildings: Map.from(other._buildings),
      users: Map.from(other._users),
    );
  }

  static IdIndexStructure fromOtherWithoutBuildings(IdIndexStructure other) {
    return IdIndexStructure(
      cards: Map.from(other._cards),
      cardInstances: Map.from(other._cardInstances),
      buildings: {},
      users: Map.from(other._users),
    );
  }

  /// a lot of unsafe code here:
  @override
  T? tryResolve<T extends IndexableResource<N>, N>(N id) => _getMap<T, N>()[id];

  Map<N, T> _getMap<T extends IndexableResource<N>, N>() {
    /// dart3 switch pattern
    if (T is Card) {
      return _cards as Map<N, T>;
    } else if (T is CardInstance) {
      return _cardInstances as Map<N, T>;
    } else if (T is Building) {
      return _buildings as Map<N, T>;
    } else if (T is User) {
      return _users as Map<N, T>;
    }
    throw Exception("dart3 exhaustive check switch pattern");
  }

  /// a lot of unsafe code here:
  @override
  T resolve<T extends IndexableResource<N>, N>(N id) {
    final result = tryResolve<T, N>(id);
    if (result == null) {
      throw Exception("cannot resolve resource of type $T with id=$id");
    }
    return result;
  }

  @override
  void insert<T extends IndexableResource<N>, N>(T item) {
    _getMap<T, N>()[item.id] = item;
  }

  @override
  void remove<T extends IndexableResource<N>, N>(N id) {
    _getMap<T, N>().remove(id);
  }
}

Map<K, T> createIndex<K, T extends IndexableResource<K>>(Iterable<T> items) =>
    Map.fromEntries(items.map((e) => MapEntry(e.id, e)));

extension TestIndexStructure on IdIndexStructure {
  static IdIndexStructure testIndexFromConfigAndMap(
      GameCreationConfig config, MapState mapState) {
    // future: out of scope
    // final Hap testHap = Hap(name: "Hap 1", delay: 2, id: "hap1");
    // final hapInstances =
    //     List.generate(13, (i) => HapInstance(id: "$i", hap: testHap));
    final Card testBuildingCard = Card(
      id: "testbuilding",
      name: "Test Building",
      cost: IngameResourceBundle(wood: 1, people: 1),
      properties: BuildingCardProperties(
        netProduction: IngameResourceBundle(people: -1, food: 2),
        suitableTiles: [TileType.forest, TileType.grass],
        relativePositions: [Int2(0, 0)],
      ),
    );

    final Card testSpellCard = Card(
      id: "testspell",
      name: "Test Spell Card",
      cost: IngameResourceBundle(wood: 1, people: 1),
      properties: SpellCardProperties(),
    );

    final List<CardInstance> cardInstances = List.generate(
        30,
        (i) => CardInstance(
            id: "ci$i", card: i % 3 == 0 ? testSpellCard : testBuildingCard));

    return IdIndexStructure(
      cards: createIndex([testBuildingCard, testSpellCard]),
      cardInstances: createIndex(cardInstances),
      buildings: {},
      users: createIndex(config.players),
    );
  }
}
