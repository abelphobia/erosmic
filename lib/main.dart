import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erosmic/models/track_info.dart';
import 'package:erosmic/pages/home_page.dart';
import 'package:erosmic/pages/mini_player.dart';
import 'package:erosmic/themes/dark_mode.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TrackInfo()..fetchAll(),
      child: const ErosmicApp(),
    ),
  );
}

class ErosmicApp extends StatelessWidget {
  const ErosmicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: darkMode,
      home: const RootPage(),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MiniPlayer(),
      body: const HomePage(),
    );
  }
}
