import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:erosmic/models/track_info.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadPlaylist();
  }

  Future<void> _loadPlaylist() async {
    final trackInfo = context.read<TrackInfo>();
    final playlist = ConcatenatingAudioSource(
      children: trackInfo.tracks
          .map((song) => AudioSource.asset(song.audioPath, tag: song))
          .toList(),
    );
    await _player.setAudioSource(playlist);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenPlayer(player: _player),
          ),
        );
      },
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Album art placeholder
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.music_note,
                color: Color.fromARGB(255, 21, 123, 170),
              ),
            ),
            const SizedBox(width: 12),

            // Song title + artist
            Expanded(
              child: StreamBuilder<SequenceState?>(
                stream: _player.sequenceStateStream,
                builder: (context, snapshot) {
                  final song = snapshot.data?.currentSource?.tag;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song?.title ?? "Not Playing",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        song?.artist ?? "—",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ),

            // Play / Pause button
            StreamBuilder<PlayerState>(
              stream: _player.playerStateStream,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                return IconButton(
                  icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    if (playing) {
                      _player.pause();
                    } else {
                      _player.play();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Full Screen Player ────────────────────────────────────────────────────────

class FullScreenPlayer extends StatefulWidget {
  final AudioPlayer player;

  const FullScreenPlayer({super.key, required this.player});

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  AudioPlayer get player => widget.player;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 71, 158, 230),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
            size: 32,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Now Playing",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Album art
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade300,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.music_note,
                size: 100,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),

            // Song info
            StreamBuilder<SequenceState?>(
              stream: player.sequenceStateStream,
              builder: (context, snapshot) {
                final song = snapshot.data?.currentSource?.tag;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song?.title ?? "Not Playing",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          song?.artist ?? "—",
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.favorite_border, color: Colors.white60),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),

            // Seek bar
            StreamBuilder<Duration>(
              stream: player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = player.duration ?? Duration.zero;
                return Column(
                  children: [
                    Slider(
                      value: position.inSeconds.toDouble().clamp(
                        0,
                        duration.inSeconds.toDouble(),
                      ),
                      min: 0,
                      max: duration.inSeconds.toDouble(),
                      onChanged: (val) =>
                          player.seek(Duration(seconds: val.toInt())),
                      activeColor: Colors.white,
                      inactiveColor: Colors.white24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _format(position),
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _format(duration),
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Playback controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Shuffle
                StreamBuilder<bool>(
                  stream: player.shuffleModeEnabledStream,
                  builder: (context, snapshot) {
                    final shuffling = snapshot.data ?? false;
                    return IconButton(
                      icon: Icon(
                        Icons.shuffle,
                        color: shuffling ? Colors.white : Colors.white38,
                      ),
                      onPressed: () => player.setShuffleModeEnabled(!shuffling),
                    );
                  },
                ),

                // Previous
                IconButton(
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                    size: 36,
                  ),
                  onPressed: () => player.seekToPrevious(),
                ),

                // Play / Pause
                StreamBuilder<PlayerState>(
                  stream: player.playerStateStream,
                  builder: (context, snapshot) {
                    final playing = snapshot.data?.playing ?? false;
                    return Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          playing ? Icons.pause : Icons.play_arrow,
                          color: Colors.deepPurple,
                          size: 32,
                        ),
                        onPressed: () {
                          if (playing) {
                            player.pause();
                          } else {
                            player.play();
                          }
                        },
                      ),
                    );
                  },
                ),

                // Next
                IconButton(
                  icon: const Icon(
                    Icons.skip_next,
                    color: Colors.white,
                    size: 36,
                  ),
                  onPressed: () => player.seekToNext(),
                ),

                // Repeat
                StreamBuilder<LoopMode>(
                  stream: player.loopModeStream,
                  builder: (context, snapshot) {
                    final mode = snapshot.data ?? LoopMode.off;
                    return IconButton(
                      icon: Icon(
                        mode == LoopMode.one ? Icons.repeat_one : Icons.repeat,
                        color: mode != LoopMode.off
                            ? Colors.white
                            : Colors.white38,
                      ),
                      onPressed: () {
                        if (mode == LoopMode.off) {
                          player.setLoopMode(LoopMode.all);
                        } else if (mode == LoopMode.all) {
                          player.setLoopMode(LoopMode.one);
                        } else {
                          player.setLoopMode(LoopMode.off);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
