import 'package:flutter/material.dart';
import 'package:flutter_miniplayer/flutter_miniplayer.dart';

class MiniPlayerWidget extends StatelessWidget {
  const MiniPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Miniplayer(
      minHeight: 80,
      maxHeight: 1000,
      builder: (height, percentage) {
        if (percentage > 0.6) {
          return Container(
            color: Colors.green,
            child: const Center(child: Text('Will fix later ')),
          );
        } else {
          return Container(
            color: Colors.amber,
            child: const Center(child: Text('mini player')),
          );
        }
      },
    );
  }
}
