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
            color: const Color.fromARGB(255, 84, 172, 245),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Expanded Player Testing',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Icon(Icons.music_note, size: 100, color: Colors.white),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      onPressed: () {
                        // play/pause functionality will be added later
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        // skip next functionality will be added later
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: () {
                        // skip previous functionality will be added later
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Container(
            color: const Color.fromARGB(255, 79, 191, 224),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'smaller player testing',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      onPressed: () {
                        // play/pause functionality will be added later
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        // skip next functionality will be added later
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: () {
                        // skip previous functionality will be added later
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
