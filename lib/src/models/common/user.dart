import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_state/game_state.dart';
import 'package:dartz/dartz.dart';

class User {
  UserId userId;
  String username;
  User({required this.userId, required this.username});
}
