import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erosmic/models/track_info.dart';
import 'package:erosmic/pages/home_page.dart';
import 'package:erosmic/pages/mini_player.dart';
import 'package:erosmic/themes/theme_setter.dart';

// Main provides all the packages that are used throughout the app. In this case Themeprovider and TrackInfo is used all throughout the page.
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TrackInfo()..fetchAll()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // Class extends allows to create a subclass that allows the Myapp page to be used all around the app
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Erosmic',
      theme: context.watch<ThemeProvider>().themeData, // from theme_setter
      home: const HomePage(),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MiniPlayer(), // place in the main home page.
      body: const HomePage(),
    );
  }
}
