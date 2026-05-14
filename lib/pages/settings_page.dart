import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erosmic/themes/theme_setter.dart';

class SettingsPage extends StatelessWidget {
  // Class extends allows to create a subclass that allows the Settings page to be used as needed.
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context
        .watch<
          ThemeProvider
        >(); // When provider calls notifylisteners, the widget rebuilds using context.watch
    // creates a basic design for dark mode
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SwitchListTile(
        title: const Text("Dark Mode"),
        value: themeProvider.isDarkMode,
        onChanged: (val) {
          context
              .read<ThemeProvider>()
              .toggleTheme(); // allows the switchlist to toggle between dark and light.
        },
      ),
    );
  }
}
