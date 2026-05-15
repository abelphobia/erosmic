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

    final colorScheme =
        Theme.of(context).colorScheme; // gets the current theme colors

    // creates a basic design for dark mode
    return Scaffold(
      backgroundColor:
          colorScheme.surface, // sets the page background based on theme
      appBar: AppBar(
        backgroundColor:
            colorScheme.surface, // keeps app bar background readable in theme
        foregroundColor:
            colorScheme.onSurface, // fixes foreground color for dark mode text/icons
        title: Text(
          "Settings",
          style: TextStyle(
            color: colorScheme.onSurface, // makes title visible in dark mode
          ),
        ),
      ),
      body: SwitchListTile(
        tileColor:
            colorScheme.surface, // keeps the tile background matched to theme
        title: Text(
          "Dark Mode",
          style: TextStyle(
            color: colorScheme.onSurface, // fixes text color in dark mode
          ),
        ),
        subtitle: Text(
          themeProvider.isDarkMode ? "Enabled" : "Disabled",
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(
              0.7,
            ), // readable subtitle color
          ),
        ),
        activeColor:
            colorScheme.primary, // uses theme primary color for the switch
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