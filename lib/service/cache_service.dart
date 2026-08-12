import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class CacheService {
  void putItem(String box, String key, dynamic value) {
    Hive.box(box).put(key, value);
  }

  dynamic getItem(String box, String key) {
    return Hive.box(box).get(key);
  }

  void removeItem(String box, String key) {
    Hive.box(box).delete(key);
  }
}
