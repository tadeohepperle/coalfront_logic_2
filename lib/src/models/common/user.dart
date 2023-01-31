import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_state.dart';
import 'package:coalfront_logic_2/src/models/game_state/indexable_resource.dart';
import 'package:dartz/dartz.dart';

class User implements IndexableResource<UserId> {
  @override
  UserId id;
  String username;
  User({required this.id, required this.username});
}
