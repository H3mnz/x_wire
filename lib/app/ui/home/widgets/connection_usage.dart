import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

import '../../../shared/entity/typedef.dart';
import '../../../shared/extension/num_ext.dart';

class ConnectionSpeed extends StatelessWidget {
  final VpnStage stage;
  final NetworkStatistics networkStatistics;
  const ConnectionSpeed({
    super.key,
    required this.networkStatistics,
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Tile(
              value: networkStatistics.download,
              icon: HugeIcons.strokeRoundedArrowDownDouble,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Center(
              child: switch (stage) {
                VpnStage.connecting || VpnStage.disconnecting => const CupertinoActivityIndicator(
                    radius: 16,
                  ),
                _ => const SizedBox.shrink(),
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Tile(
              value: networkStatistics.upload,
              icon: HugeIcons.strokeRoundedArrowUpDouble,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final int value;
  final IconData icon;
  final Color color;
  const Tile({
    super.key,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(2),
            child: Icon(
              icon,
              color: color,
              size: 24,
              shadows: [
                BoxShadow(
                  color: color,
                  blurRadius: 6,
                  blurStyle: BlurStyle.outer,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.formatBytes,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
