import 'package:flutter/material.dart';
import 'package:flutter_miniplayer/flutter_miniplayer.dart';

class MiniPlayerWidget extends StatelessWidget {
  const MiniPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Miniplayer(
      minHeight: 100,
      maxHeight: 1000,
      builder: (height, percentage) {
        if (percentage > 0.6) {
          return Container(
            color: Colors.green,
            child: const Center(child: Text('Will fix later ')),
          );
        } else {
          return Container(
            color: const Color.fromARGB(255, 79, 191, 224),
            child: const Center(child: Text('Now Playing')),
          );
        }
      },
    );
  }
}
