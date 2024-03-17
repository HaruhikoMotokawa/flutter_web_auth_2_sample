import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'regular_storage.g.dart';

class RegularStorage {
  final _isFirstLunchKey = 'is_first_lunch';
  Future<void> updateIsFirstLunch(bool isFirstLunch) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_isFirstLunchKey, isFirstLunch);
  }

  Future<bool?> getIsFirstLunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstLunchKey);
  }
}

@Riverpod(keepAlive: true)
RegularStorage regularStorage(RegularStorageRef ref) {
  return RegularStorage();
}
