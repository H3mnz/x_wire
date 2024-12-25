import 'dart:ui';

import '../entity/config_entity.dart';
import '../entity/typedef.dart';
import 'logger.dart';

class Utils {
  Utils._();
  static const String appLabel = 'XWire';
  static Size windowSize = const Size(360, 640);
  static String twoDigits(int n) => n.toString().padLeft(2, "0");

  static ConfigEntity? parseConfig(String config) {
    try {
      final lines = config.split('\n');

      final address = lines.firstWhere(
        (element) => element.contains('Address'),
        orElse: () => '',
      );
      final endpoint = lines.firstWhere(
        (element) => element.contains('Endpoint'),
        orElse: () => '',
      );
      final privateKey = lines.firstWhere(
        (element) => element.contains('PrivateKey'),
        orElse: () => '',
      );
      final publicKey = lines.firstWhere(
        (element) => element.contains('PublicKey'),
        orElse: () => '',
      );
      if (address.isNotEmpty && endpoint.isNotEmpty && privateKey.isNotEmpty && publicKey.isNotEmpty) {
        return ConfigEntity(
          address: address.split('=').last.trim(),
          endpoint: endpoint.split('=').last.trim(),
          privateKey: privateKey.split('=').last.trim(),
          publicKey: publicKey.split('=').last.trim(),
        );
      }
    } on Exception catch (e) {
      Logger.log(e.toString(), LogLevel.error);
    }
    return null;
  }

  static NetworkStatistics kNetworkStatistics = (download: 0, upload: 0);

  static const String encryptionKey = 'a0f97f028044672600c353b17fb62bc7';

  static double lerpDouble(num a, num b, double t) {
    if (a == b || (a.isNaN) && (b.isNaN)) {
      return a.toDouble();
    }

    assert(a.isFinite, 'Cannot interpolate between finite and non-finite values');
    assert(b.isFinite, 'Cannot interpolate between finite and non-finite values');
    assert(t.isFinite, 't must be finite when interpolating between values');
    return a * (1.0 - t) + b * t;
  }

  static NetworkStatistics? parseStatistics(String output) {
    try {
      final collection = output.split('\n').where(
            (element) => element.trim().isNotEmpty,
          );

      final lst = collection.last.split(' ').where((element) => element.isNotEmpty).toList();
      return (download: int.parse(lst[2]), upload: int.parse(lst[3]));
    } on Exception catch (e) {
      Logger.log(e.toString(), LogLevel.error);
    }
    return null;
  }
}
