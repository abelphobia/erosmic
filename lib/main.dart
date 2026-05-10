import 'package:erosmic/models/track_info.dart';
import 'package:flutter/material.dart';
import "package:erosmic/themes/theme_setter.dart";
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'playlists_page.dart';
import 'genre_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TrackInfo()),
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
      home: HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}