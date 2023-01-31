import 'package:uuid/uuid.dart';

typedef CardId = String;

typedef CardInstanceId = String;

typedef HapId = String;

typedef HapInstanceId = String;

typedef BuildingId = String;

typedef GameId = String;

typedef UserId = String;

final uuid = Uuid();

String generateUniqueId() => uuid.v4();

String generateUniqueIdWithLength([
  int length = 5,
  Iterable<String> takenIds = const [],
  int maxTrys = 100,
]) {
  String id;
  int c = 0;
  do {
    id = uuid.v4().substring(0, length);
    c++;
    if (c++ >= maxTrys) {
      throw Exception(
        "could not generateUniqueIdWithLength with $maxTrys trys.",
      );
    }
  } while (takenIds.contains(id));
  return id;
}
