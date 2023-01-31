import 'package:coalfront_logic_2/src/models/common/ids.dart';

/// Start-Of-Turn Events. Hap is according to https://www.merriam-webster.com/thesaurus/hap a synonym of event

class CoalfrontHap {
  int delay;
  HapId hapId;
  CoalfrontHap({
    required this.delay,
    required this.hapId,
  });

  /// todo: effect
}
