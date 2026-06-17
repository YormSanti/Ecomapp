import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'first_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ValueNotifier<bool> _gridViewNotifier = ValueNotifier<bool>(true);

  void _toggleGridStyle() {
    _gridViewNotifier.value = !_gridViewNotifier.value;
  }

  List<PersistentTabConfig> _tabs(BuildContext context) {
    final foregroundColor = Theme.of(context).colorScheme.onSurface;

    return [
      PersistentTabConfig(
        screen: FirstScreen(
          isDarkMode: widget.isDarkMode,
          gridViewNotifier: _gridViewNotifier,
          onToggleTheme: widget.onToggleTheme,
          onToggleGridStyle: _toggleGridStyle,
        ),
        item: ItemConfig(
          icon: const Icon(Icons.home),
          title: 'Home',
          activeForegroundColor: foregroundColor,
        ),
      ),
      PersistentTabConfig(
        screen: const _CenterTab(
          icon: Icons.search,
          label: 'Search',
          color: Color(0xffffeef4),
        ),
        item: ItemConfig(
          icon: const Icon(Icons.search),
          title: 'Search',
          activeForegroundColor: foregroundColor,
        ),
      ),
      PersistentTabConfig(
        screen: SettingsScreen(
          isDarkMode: widget.isDarkMode,
          gridViewNotifier: _gridViewNotifier,
          onToggleTheme: widget.onToggleTheme,
          onToggleGridStyle: _toggleGridStyle,
        ),
        item: ItemConfig(
          icon: const Icon(Icons.settings),
          title: 'Settings',
          activeForegroundColor: foregroundColor,
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _gridViewNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      key: ValueKey(widget.isDarkMode),
      tabs: _tabs(context),
      navBarBuilder: (navBarConfig) => Style2BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(color: Colors.pink.shade200),
      ),
    );
  }
}

class _CenterTab extends StatelessWidget {
  const _CenterTab({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        title: Text(label),
      ),
      body: Center(child: Icon(icon, size: 72, color: Colors.pink)),
    );
  }
}
