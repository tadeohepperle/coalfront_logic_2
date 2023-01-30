import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_state.dart';
import 'package:dartz/dartz.dart';

import '../player_actions/i_viewable.dart';

class User implements IViewable<User, Unit>, PublicView<Unit> {
  UserId userId;
  String username;
  User({required this.userId, required this.username});

  @override
  User getView(GameStateUnmodifyable gameState, User user) {
    // TODO: implement getView
    throw UnimplementedError();
  }

  @override
  Unit? privateView;
}
