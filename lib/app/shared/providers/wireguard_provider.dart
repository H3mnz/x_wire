import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

import '../entity/typedef.dart';
import '../services/wireguard_service.dart';
import '../utils/utils.dart';

final wireguardProvider = Provider<WireguardService>((ref) {
  final wireguard = WireguardService.instance;

  wireguard.stage.stream.listen(
    (stage) {
      ref.read(stageProvider.notifier).update(
            (state) => stage,
          );
    },
  );
  // networkStatistics
  wireguard.networkStatistics.stream.listen(
    (statistics) {
      ref.read(networkStatisticsProvider.notifier).update(
            (state) => statistics,
          );
    },
  );
  // connectingTime
  wireguard.connectingTime.stream.listen(
    (duration) {
      ref.read(connectingTimeProvider.notifier).update(
            (state) => duration,
          );
    },
  );

  return wireguard;
});

final stageProvider = StateProvider<VpnStage>((ref) {
  return VpnStage.disconnected;
});
final connectingTimeProvider = StateProvider<Duration>((ref) {
  return Duration.zero;
});

final networkStatisticsProvider = StateProvider<NetworkStatistics>((ref) {
  return Utils.kNetworkStatistics;
});
