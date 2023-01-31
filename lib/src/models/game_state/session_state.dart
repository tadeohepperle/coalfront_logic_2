import 'package:coalfront_logic_2/src/models/common/user.dart';
import '../common/ids.dart';

class SessionState {
  UserId owner;
  List<UserId> playersJoined;
  SessionState({
    required this.owner,
    required this.playersJoined,
  });
}
