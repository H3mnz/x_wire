import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../exceptions/exceptions.dart';
import '../utils/utils.dart';

class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();
  late Box<String> _configsBox;

  bool isInitialized = false;

  Future<void> init() async {
    if (isInitialized) return;

    await Hive.initFlutter(Utils.appLabel);
    _configsBox = await Hive.openBox<String>(
      'configs',
      encryptionCipher: HiveAesCipher(utf8.encode(Utils.encryptionKey)),
    );
    isInitialized = true;
  }

  ValueListenable<Box<String>> get listenable => _configsBox.listenable();

  Future<void> addConfig(String config) async {
    try {
      final entity = Utils.parseConfig(config);
      if (entity == null) throw WireguradException('Failed to parse config.');
      if (_configsBox.containsKey(entity.privateKey)) throw WireguradException('Config already exists.');
      return _configsBox.put(entity.privateKey, config);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteConfig(String config) async {
    try {
      final entity = Utils.parseConfig(config);
      if (entity == null) throw Exception('Failed to parse config');
      return _configsBox.delete(entity.privateKey);
    } catch (e) {
      rethrow;
    }
  }
}
