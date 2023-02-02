import 'package:coalfront_logic_2/src/models/common/int2.dart';
import 'package:coalfront_logic_2/src/models/game_events/game_event.dart';
import 'package:coalfront_logic_2/src/models/player_actions/player_action.dart';
import 'package:coalfront_logic_2/src/models/player_input_actions/player_input_action.dart';

import '../models/ui_events/ui_event.dart';

/// This
///
/// receives GameEvents from a GameManager
/// processed them
/// sends UIEvents out that a UI Layer can use to display the game.
///
/// receives PlayerInputActions
/// processed them (*)
/// sends PlayerActions to Server
///
/// (*) this does not generate secret knowledge,
/// the client just makes sure predictions to visualize
/// the results of the player input faster without
/// server roundtrip.
/// E.g. player builds a building => it immediately appears
/// Though at any point the client could be deleted and recreated (gets new InitialData from server)
/// and the internal state afterwards will not differ in a visible way.
/// The Client should always be a 100% reflection of what the serverstate of the world is.
/// Though the GameState on the Server has more knowledge and the Client only sees a part of it.
/// This ensures only player relevant data is sent to the client.
/// for example nowhere on the clients machine there will be any information at any time,
/// what cards other players have in their hands or other secret information.
/// What the player can see, should be 100% of what the client knows.
abstract class IGameManagerClient {
  /// from server
  void receiveGameEvent(GameEvent gameEvent);

  /// for/towards UI
  Stream<UiEvent> get uiEvents;

  /// todo? maybe split into seperate functions that return values
  ///
  /// from UI
  void receivePlayerInputAction(PlayerInputAction playerInputAction);

  /// for/towards Server
  Stream<PlayerAction> get playerActions;

  bool canSeeMapPosition(Int2 position);
}
