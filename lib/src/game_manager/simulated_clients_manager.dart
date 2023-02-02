import 'package:coalfront_logic_2/src/game_manager/game_manager_client.dart';
import 'package:coalfront_logic_2/src/game_manager/game_manager_client_logger.dart';
import 'package:coalfront_logic_2/src/game_manager/i_simulated_clients_manager.dart';
import 'package:coalfront_logic_2/src/models/game_events/game_event.dart';
import 'package:coalfront_logic_2/src/models/game_events/game_state_view.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_state.dart';

import '../models/common/ids.dart';
import 'i_game_manager_client.dart';

class SimulatedClientsManager implements ISimulatedClientsManager {
  List<UserId> users;
  Map<UserId, IGameManagerClient> clients;

  SimulatedClientsManager._({
    required this.users,
    required this.clients,
  });

  factory SimulatedClientsManager.fromGameState(GameState gameState) {
    final users = gameState.indexStructure.userIds.toList();
    Map<UserId, IGameManagerClient> clients = {};
    for (final userId in users) {
      /// todo: dependency injection instead of this logger
      final client =
          GameManagerClient(userId: userId, logger: GameManagerClientLogger());
      client.receiveGameEvent(GameStateView.fromState(gameState, userId));
      clients[userId] = client;
    }
    return SimulatedClientsManager._(users: users, clients: clients);
  }

  @override
  void receiveGameEvent(UserId userId, GameEvent gameEvent) {
    clients[userId]!.receiveGameEvent(gameEvent);
  }
}
