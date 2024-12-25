import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

import '../../../shared/extension/toastification_ext.dart';
import '../../../shared/providers/wireguard_provider.dart';
import '../../configs/providers/selected_config_provider.dart';
import '../../main/providers/current_index_provider.dart';
import '../widgets/connection_status.dart';
import '../widgets/connection_switch.dart';
import '../widgets/connection_time.dart';
import '../widgets/connection_usage.dart';
import '../widgets/map_background.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wireguard = ref.read(wireguardProvider);
    final stage = ref.watch(stageProvider);
    final connectingTime = ref.watch(connectingTimeProvider);
    final networkStatistics = ref.watch(networkStatisticsProvider);
    final selectedConfig = ref.watch(selectedConfigProvider);
    return MapBackground(
      child: Column(
        children: [
          const Spacer(),
          ConnectingTime(duration: connectingTime),
          const SizedBox(height: 8),
          ConnectionStatus(stage: stage),
          const SizedBox(height: 16),
          ConnectionSwitch(
            stage: stage,
            onPressed: () async {
              if (stage == VpnStage.connected) {
                return wireguard.disconnect();
              } else if (selectedConfig == null) {
                toastification.showSimple(title: const Text('Please select config'));
                ref.read(currentIndexProvider.notifier).update((state) => 1);
              } else if (stage == VpnStage.disconnected) {
                wireguard.connect(selectedConfig);
              }
            },
          ),
          const SizedBox(height: 8),
          ConnectionSpeed(stage: stage, networkStatistics: networkStatistics)
        ],
      ),
    );
  }
}
