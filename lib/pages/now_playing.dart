import 'package:flutter/material.dart';
import 'package:erosmic/categories/my_drawer.dart';

class NowPlayingPage extends StatelessWidget {
  const NowPlayingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text("N O W   P L A Y I N G")),
      drawer: const MyDrawer(),
    );
  }
}
