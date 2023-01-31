import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_state/ingame/coalfront_hap.dart';

class CoalfrontHapInstance {
  HapInstanceId hapInstanceId;
  CoalfrontHap hap;
  CoalfrontHapInstance({
    required this.hapInstanceId,
    required this.hap,
  });
}
