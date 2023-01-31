import 'package:coalfront_logic_2/src/models/common/ids.dart';
import 'package:coalfront_logic_2/src/models/game_state/indexable_resource.dart';

/// Start-Of-Turn Events. Hap is according to https://www.merriam-webster.com/thesaurus/hap a synonym of event

class Hap implements IndexableResource<HapId> {
  int delay;
  @override
  HapId id;
  String name;
  Hap({
    required this.delay,
    required this.name,
    required this.id,
  });

  /// todo: effect
}
