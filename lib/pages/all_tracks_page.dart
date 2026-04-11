import 'package:flutter/material.dart';

class AllTracksPage extends StatelessWidget {
  const AllTracksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text("A L L   T R A C K S")),
    );
  }
}
