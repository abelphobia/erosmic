import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erosmic/themes/theme_setter.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SwitchListTile(
        title: const Text("Dark Mode"),
        value: themeProvider.isDarkMode,
        onChanged: (val) {
          context.read<ThemeProvider>().toggleTheme();
        },
      ),
    );
  }
}
