import 'package:coalfront_logic_2/src/models/common/game_creation_config.dart';
import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_state/i_resources_index.dart';
import 'package:coalfront_logic_2/src/models/game_state/indexable_resource.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/card.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/card_instance.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/hap.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/hap_instance.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/ingame_resource_bundle.dart';

import '../common/user.dart';
import 'functions/functions.dart';
import 'ingame/building.dart';

class IdIndexStructure implements IResourcesIndex {
  final Map<HapId, Hap> _haps;
  final Map<HapInstanceId, HapInstance> _hapInstances;
  final Map<CardId, Card> _cards;
  final Map<CardInstanceId, CardInstance> _cardInstances;
  final Map<BuildingId, Building> _buildings;
  final Map<UserId, User> _users;

  Iterable<Hap> get haps => _haps.values;
  Iterable<HapId> get hapIds => _haps.keys;
  Iterable<HapInstance> get hapInstances => _hapInstances.values;
  Iterable<HapInstanceId> get hapInstanceIds => _hapInstances.keys;
  Iterable<Card> get cards => _cards.values;
  Iterable<CardId> get cardIds => _cards.keys;
  Iterable<CardInstance> get cardInstances => _cardInstances.values;
  Iterable<CardInstanceId> get cardInstanceIds => _cardInstances.keys;
  Iterable<Building> get buildings => _buildings.values;
  Iterable<BuildingId> get buildingIds => _buildings.keys;
  Iterable<User> get users => _users.values;
  Iterable<UserId> get userIds => _users.keys;

  IdIndexStructure({
    required Map<HapId, Hap> haps,
    required Map<HapInstanceId, HapInstance> hapInstances,
    required Map<CardId, Card> cards,
    required Map<CardInstanceId, CardInstance> cardInstances,
    required Map<BuildingId, Building> buildings,
    required Map<UserId, User> users,
  })  : _haps = haps,
        _hapInstances = hapInstances,
        _cards = cards,
        _cardInstances = cardInstances,
        _buildings = buildings,
        _users = users;

  IdIndexStructure copyWithBuildings(Iterable<Building> buildings) {
    return IdIndexStructure(
        haps: _haps,
        hapInstances: _hapInstances,
        cards: _cards,
        cardInstances: _cardInstances,
        buildings: createIndex(buildings),
        users: _users);
  }

  factory IdIndexStructure.testIndexFromConfig(GameCreationConfig config) {
    // todo:
    // generate 10 test haps:
    final Hap testHap = Hap(name: "Hap 1", delay: 2, id: "hap1");
    final hapInstances =
        List.generate(13, (i) => HapInstance(id: "$i", hap: testHap));
    final Card testBuildingCard = Card(
      id: "testbuilding",
      name: "Test Building",
      cost: IngameResourceBundle(wood: 1, people: 1),
      properties: BuildingCardProperties(
        turnCost: IngameResourceBundle(),
        turnEarning: IngameResourceBundle(),
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

    // set initial player buildings:
    final baseBuildings = <Building>[];
    final basePositions =
        generatePlayerBasePositions(config.players.length, config.mapSize);
    for (var i = 0; i < config.players.length; i++) {
      final player = config.players[i];
      final baseBuilding = Building(
        id: generateUniqueId(),
        positions: basePositions[i],
        buildingType: CoalfrontBaseBuilding(owner: player.id),
      );
      baseBuildings.add(baseBuilding);
    }

    return IdIndexStructure(
      haps: createIndex([testHap]),
      hapInstances: createIndex(hapInstances),
      cards: createIndex([testBuildingCard, testSpellCard]),
      cardInstances: createIndex(cardInstances),
      buildings: createIndex(baseBuildings),
      users: createIndex(config.players),
    );
  }

  /// a lot of unsafe code here:
  @override
  T resolve<T extends IndexableResource<N>, N>(N id) {
    /// dart3 switch pattern and make IndexableResource sealed
    if (T is Hap) {
      return _haps[id]! as T;
    } else if (T is HapInstance) {
      return _hapInstances[id]! as T;
    } else if (T is Card) {
      return _cards[id]! as T;
    } else if (T is CardInstance) {
      return _cardInstances[id]! as T;
    } else if (T is Building) {
      return _buildings[id]! as T;
    } else if (T is User) {
      return _users[id]! as T;
    }
    throw Exception("cannot resolve resource of type $T with id=$id");
  }
}

Map<K, T> createIndex<K, T extends IndexableResource<K>>(Iterable<T> items) =>
    Map.fromEntries(items.map((e) => MapEntry(e.id, e)));
