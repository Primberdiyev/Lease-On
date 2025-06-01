import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:rentora/feature/models/user_model.dart';

class HiveService {
  static const _userBoxName = 'users';
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      final appDocumentDir =
          await path_provider.getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);

      if (!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
        Hive.registerAdapter(UserModelAdapter());
      }

      await Hive.openBox<UserModel>(_userBoxName);
      _isInitialized = true;
    } catch (e) {
      throw Exception('Hive initialization failed: $e');
    }
  }

  Future<void> registerUser(UserModel user) async {
    if (!_isInitialized) await init();

    try {
      final box = Hive.box<UserModel>(_userBoxName);
      await box.put(user.email, user);
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  Future<UserModel?> getUser(String email) async {
    if (!_isInitialized) await init();

    try {
      final box = Hive.box<UserModel>(_userBoxName);
      return box.get(email);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<bool> validateUser(String email, String password) async {
    if (!_isInitialized) await init();

    try {
      final user = await getUser(email);
      return user != null && user.password == password;
    } catch (e) {
      throw Exception('Validation failed: $e');
    }
  }

  Future<bool> isEmailRegistered(String email) async {
    if (!_isInitialized) await init();

    try {
      final user = await getUser(email);
      return user != null;
    } catch (e) {
      throw Exception('Email check failed: $e');
    }
  }

  Future<void> close() async {
    if (_isInitialized) {
      await Hive.close();
      _isInitialized = false;
    }
  }
}
