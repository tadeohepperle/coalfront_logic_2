import 'package:coalfront_logic_2/src/models/game_state/indexable_resource.dart';

/// dart3 interface
abstract class IResourcesIndex {
  T? tryResolve<T extends IndexableResource<N>, N>(N id);

  T resolve<T extends IndexableResource<N>, N>(N id);

  void insert<T extends IndexableResource<N>, N>(T item);

  void remove<T extends IndexableResource<N>, N>(N id);
}
