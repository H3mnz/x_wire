import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:toastification/toastification.dart';

import '../../../shared/exceptions/exceptions.dart';
import '../../../shared/extension/toastification_ext.dart';
import '../../../shared/providers/wireguard_provider.dart';
import '../../../shared/services/storage_service.dart';
import '../../../shared/theme/colors.dart';
import '../../../shared/utils/utils.dart';
import '../providers/selected_config_provider.dart';
import '../widgets/config_details.dart';
import '../widgets/config_tile.dart';

class ConfigsPage extends ConsumerWidget {
  const ConfigsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wireguard = ref.watch(wireguardProvider);
    final selectedConfig = ref.watch(selectedConfigProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const Text('Configs'),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                final result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: ['conf'],
                );
                if (result == null) return;
                final config = await result.xFiles.first.readAsString();
                if (Utils.parseConfig(config) != null) {
                  await StorageService.instance.addConfig(config);
                  if (!context.mounted) return;
                  toastification.dismissAll();
                  toastification.showSimple(
                    title: Text(
                      'Config added.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    color: AppColors.green,
                  );
                }
              } on WireguradException catch (e) {
                if (!context.mounted) return;

                toastification.showSimple(
                  title: Text(
                    e.message,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  color: AppColors.red,
                );
              }
            },
            icon: const Icon(HugeIcons.strokeRoundedAdd01),
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: StorageService.instance.listenable,
        builder: (context, box, child) {
          final list = box.values.toList();
          if (list.isEmpty) {
            return const SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    HugeIcons.strokeRoundedFileMusic,
                    size: 48,
                    color: Colors.white54,
                  ),
                  SizedBox(height: 8),
                  Text('No Configs'),
                ],
              ),
            );
          }
          return ListView.separated(
            itemCount: list.length,
            // reverse: true,
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final config = list[index];
              return ConfigTile(
                selected: selectedConfig == config,
                title: Utils.parseConfig(config)?.endpoint ?? 'Unknown endpoint',
                onTap: () {
                  ref.read(selectedConfigProvider.notifier).update(
                        (state) => config,
                      );
                },
                onCopy: () async {
                  await Clipboard.setData(
                    ClipboardData(text: list[index]),
                  );
                  if (!context.mounted) return;

                  toastification.showSimple(
                    title: Text(
                      'Config copied',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    color: AppColors.green,
                  );
                },
                onDelete: () async {
                  await wireguard.disconnect();
                  await StorageService.instance.deleteConfig(config);
                  ref.read(selectedConfigProvider.notifier).update(
                        (state) => null,
                      );
                  if (!context.mounted) return;

                  toastification.showSimple(
                    title: Text(
                      'Config deleted',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    color: AppColors.green,
                  );
                },
                onDetails: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  elevation: 20,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  showDragHandle: true,
                  builder: (context) => ConfigDetails(config: config),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
