import 'dart:async';
import 'dart:io';

import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

import '../entity/typedef.dart';
import '../exceptions/exceptions.dart';
import '../utils/logger.dart';
import '../utils/utils.dart';

class WireguardService {
  WireguardService._();

  static final WireguardService instance = WireguardService._();

  final wireguard = WireGuardFlutter.instance;

  Timer? timer;

  final StreamController<VpnStage> stage = StreamController<VpnStage>.broadcast();
  final StreamController<Duration> connectingTime = StreamController<Duration>.broadcast();
  final StreamController<NetworkStatistics> networkStatistics = StreamController<NetworkStatistics>.broadcast();

  Future<void> initialize() async {
    try {
      await wireguard.initialize(interfaceName: 'XWire Tunnel');
      Logger.log("Wireguard initialized", LogLevel.success);
      final perviousStage = await wireguard.stage();
      if (perviousStage == VpnStage.connected) await disconnect();

      wireguard.vpnStageSnapshot.listen(
        (stage) async {
          if (stage == VpnStage.connected) {
            final interface = await getInterfaceName();
            if (interface != null) {
              timer = Timer.periodic(
                const Duration(milliseconds: 1500),
                (timer) async {
                  connectingTime.add(Duration(seconds: timer.tick));
                  networkStatistics.add(await getNetworkStatistics(interface));
                },
              );
            }
          } else if (stage == VpnStage.disconnected) {
            timer?.cancel();
            timer = null;
            connectingTime.add(Duration.zero);
            networkStatistics.add(Utils.kNetworkStatistics);
          }
          this.stage.add(stage);
          Logger.log("status changed $stage");
        },
      );
    } catch (error, stack) {
      Logger.log("Failed to initialize: $error\n$stack", LogLevel.error);
      throw WireguradException(error.toString());
    }
  }

  Future<String?> getInterfaceName() async {
    try {
      final process = await Process.run('netsh', [
        "interface",
        "ip",
        "show",
        "subinterfaces",
      ]);
      if (process.stdout case final String output) {
        final collection = output.split('\n').where((element) => element.trim().isNotEmpty);
        for (var element in collection) {
          final list = element.trim().split(' ').where((element) => element.isNotEmpty);
          for (var element in list) {
            if (element.endsWith('.tmp')) {
              return element;
            }
          }
        }
      }
    } on Exception catch (e) {
      Logger.log(e.toString(), LogLevel.error);
    }
    return null;
  }

  Future<NetworkStatistics> getNetworkStatistics(String interface) async {
    try {
      final process = await Process.run('netsh', [
        "interface",
        "ip",
        "show",
        "subinterfaces",
        interface,
      ]);
      if (process.stdout case final String output) {
        final statistics = Utils.parseStatistics(output);

        return statistics ?? (download: 0, upload: 0);
      }
    } on Exception catch (e) {
      Logger.log(e.toString(), LogLevel.error);
    }
    return (download: 0, upload: 0);
  }

  Future<void> connect(String config) async {
    try {
      if (!(await Connectivity().checkConnection())) throw WireguradException("No Connection");
      final serverAddress = Utils.parseConfig(config)?.address;
      if (serverAddress == null) throw WireguradException("Failed to parse serverAddress from config");

      await wireguard.startVpn(
        serverAddress: serverAddress,
        wgQuickConfig: config,
        providerBundleIdentifier: 'wire.x.wire',
      );
    } catch (error) {
      throw WireguradException(error.toString());
    }
  }

  Future<void> disconnect() async {
    try {
      await wireguard.stopVpn();
    } catch (error) {
      throw WireguradException(error.toString());
    }
  }

  Future<void> dispose() async {
    timer?.cancel();
    timer = null;
    await disconnect();
    stage.close();
    networkStatistics.close();
    connectingTime.close();
    Logger.log('Wireguard disposed', LogLevel.success);
  }
}
