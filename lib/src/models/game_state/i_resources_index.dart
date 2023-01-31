import 'package:coalfront_logic_2/src/models/game_state/indexable_resource.dart';

/// dart3 interface
abstract class IResourcesIndex {
  T resolve<T extends IndexableResource<N>, N>(N id);
}
