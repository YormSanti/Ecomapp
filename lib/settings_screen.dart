import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.gridViewNotifier,
    required this.onToggleTheme,
    required this.onToggleGridStyle,
  });

  final bool isDarkMode;
  final ValueNotifier<bool> gridViewNotifier;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleGridStyle;

  static const _logo =
      'https://cdn-icons-png.flaticon.com/512/4712/4712109.png';

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: gridViewNotifier,
      builder: (context, isGridView, _) {
        return Scaffold(
          backgroundColor: isDarkMode ? const Color(0xff160b0f) : null,
          appBar: AppBar(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            title: const Text('Settings'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Image.network(
                _logo,
                height: 200,
                errorBuilder: (_, _, _) {
                  return const SizedBox(
                    height: 200,
                    child: Icon(Icons.settings, size: 96, color: Colors.pink),
                  );
                },
              ),
              const Divider(),
              Card(
                color: isDarkMode ? const Color(0xff24171c) : null,
                child: ListTile(
                  leading: const Icon(Icons.lightbulb),
                  title: Text(
                    'Switched to ${isDarkMode ? "Dark" : "Light"} Mode',
                  ),
                  trailing: Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  ),
                  onTap: onToggleTheme,
                ),
              ),
              Card(
                color: isDarkMode ? const Color(0xff24171c) : null,
                child: ListTile(
                  leading: const Icon(Icons.style),
                  title: Text(
                    'Switched to ${isGridView ? "Grid" : "List"} Style',
                  ),
                  trailing: Icon(isGridView ? Icons.grid_view : Icons.list),
                  onTap: onToggleGridStyle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
