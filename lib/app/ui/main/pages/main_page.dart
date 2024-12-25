import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../configs/pages/configs_page.dart';
import '../../home/pages/home_page.dart';
import '../../settings/pages/settings_page.dart';
import '../providers/current_index_provider.dart';
import '../widgets/nav_bar.dart';
import '../widgets/title_bar.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentIndexProvider);

    return Scaffold(
      appBar: const TitleBar(),
      body: IndexedStack(
        index: currentIndex,
        children: const [HomePage(), ConfigsPage(), SettingsPage()],
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}
