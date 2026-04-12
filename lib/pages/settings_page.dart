import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erosmic/themes/theme_setter.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text("S E T T I N G S")),
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // dark mode toggle
            const Text(
              "Dark Mode",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            // switch
            Switch(
              value: Provider.of<ThemeProvider>(context).isDarkMode,
              onChanged: (value) {
                Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).toggleTheme();
              },
            ),
          ],
        ),
      ),
    );
  }
}
