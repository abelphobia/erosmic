import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erosmic/models/track_info.dart';
import 'package:erosmic/pages/home_page.dart';
import 'package:erosmic/pages/mini_player.dart';
import 'package:erosmic/themes/theme_setter.dart';

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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Erosmic',
      theme: context.watch<ThemeProvider>().themeData,
      home: const HomePage(),
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
