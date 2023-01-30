import 'package:coalfront_logic_2/src/models/game_state/game_state.dart';

import '../common/user.dart';

/// interface

abstract class IViewable<P extends PublicView<PP>, PP> {
  P getView(GameStateUnmodifyable gameState, User user);
}

abstract class PublicView<PrivateView> {
  PrivateView? privateView;
}
