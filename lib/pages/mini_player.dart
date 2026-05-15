// although named miniplayer originally, coming both the miniplayer and the full player
// together was a better and faster option as it is all on one page.

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // general audio player package
import 'package:provider/provider.dart'; // from pubspec.yaml
import 'package:erosmic/models/track_info.dart';
import 'package:erosmic/models/song.dart';

class MiniPlayer extends StatefulWidget {
  // can be placed on multiple apps and can be rebuild
  const MiniPlayer({super.key}); // super key accepts an optional key parameter

  @override // This allows flutter to create a state class with the statefulwidget
  State<MiniPlayer> createState() => _MiniPlayerState();
}

// Allows the miniplayer to be defined by using the state class
// since _player is being used, Audioplayer will create an instance
// and will be able to play music through the audio player
class _MiniPlayerState extends State<MiniPlayer> {
  final AudioPlayer _player = AudioPlayer();
  TrackInfo? _trackInfo; // finds the music info from trackinfo
  bool hasUserInitiated = false;

  @override
  // void dCD determines if dependency tracking is working properly
  // dependency tracking is important to allow relationships from data
  // to work properly and efficently
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Remove old listener if already attached
    _trackInfo?.removeListener(_onTrackChanged);

    // Attach new listener to updated TrackInfo
    _trackInfo = context.read<TrackInfo>();
    _trackInfo!.addListener(_onTrackChanged);

    _loadPlaylist(); // fetches music data
  }

  Future<void> _loadPlaylist() async {
    // syncs the data onto the app
    final tracks = _trackInfo?.tracks ?? []; // gets the track list
    if (tracks.isEmpty) return; // returns if no list

    // creates a list for the just_audio source.
    // this sorts the music based from each audio source.
    final playlist = ConcatenatingAudioSource(
      children: tracks.map((song) {
        if (song.sourceType == AudioSourceType.local) {
          return AudioSource.file(song.audioPath!, tag: song);
        } else {
          return AudioSource.uri(Uri.parse(song.streamUrl!), tag: song);
        }
      }).toList(),
    );

    await _player.setAudioSource(playlist); // standby for full sync for
  }

  void _onTrackChanged() async {
    final trackInfo = _trackInfo;
    if (trackInfo == null) return;

    final index = trackInfo.currentTrackIndex;
    final tracks = trackInfo.tracks;
    if (tracks.isEmpty) return;

    // Reload playlist if tracks were added
    if (_player.sequence == null || _player.sequence!.length != tracks.length) {
      await _loadPlaylist();
    }

    if (index < 0 || index >= (_player.sequence?.length ?? 0)) return;
    await _player.seek(Duration.zero, index: index);

    if (trackInfo.hasUserInitiated) {
      await _player.play(); // only auto-play if user tapped a track
    }
  }

  @override
  void dispose() {
    _trackInfo?.removeListener(_onTrackChanged);
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
            // Album art
            StreamBuilder<SequenceState?>(
              stream: _player.sequenceStateStream,
              builder: (context, snapshot) {
                final song = snapshot.data?.currentSource?.tag as Song?;
                return Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: song?.albumArtUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            song!.albumArtUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, er, stack) => const Icon(
                              Icons.music_note,
                              color: Color.fromARGB(255, 21, 123, 170),
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.music_note,
                          color: Color.fromARGB(255, 21, 123, 170),
                        ),
                );
              },
            ),
            const SizedBox(width: 12),

            // Song title + artist
            Expanded(
              child: StreamBuilder<SequenceState?>(
                stream: _player.sequenceStateStream,
                builder: (context, snapshot) {
                  final song = snapshot.data?.currentSource?.tag as Song?;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song?.title ?? "Not Playing",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          if (song != null)
                            Container(
                              margin: const EdgeInsets.only(right: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: song.sourceType == AudioSourceType.stream
                                    ? Colors.deepPurple.shade100
                                    : Colors.green.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                song.sourceType == AudioSourceType.stream
                                    ? "Jellyfin"
                                    : "Local",
                                style: TextStyle(
                                  fontSize: 9,
                                  color:
                                      song.sourceType == AudioSourceType.stream
                                      ? Colors.deepPurple
                                      : Colors.green.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              song?.artist ?? "—",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),

            // Play / Pause
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
  // queue model

  void _showQueue(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) {
            final sequence = player.sequence ?? [];
            final currentIndex = player.currentIndex ?? 0;

            if (sequence.isEmpty) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    "Queue is empty",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }

            return SizedBox(
              height: 500,
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Up Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: ListView.builder(
                      itemCount: sequence.length,
                      itemBuilder: (context, index) {
                        final source = sequence[index];
                        final song = source.tag as Song;

                        final isCurrent = index == currentIndex;

                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: song.albumArtUrl != null
                                ? Image.network(
                                    song.albumArtUrl!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.music_note),
                                  )
                                : Container(
                                    width: 50,
                                    height: 50,
                                    color: const Color.fromARGB(
                                      255,
                                      22,
                                      55,
                                      202,
                                    ),
                                    child: const Icon(
                                      Icons.music_note,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),

                          title: Text(
                            song.title,
                            style: TextStyle(
                              color: isCurrent
                                  ? Colors.deepPurpleAccent
                                  : Colors.white,
                              fontWeight: isCurrent
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),

                          subtitle: Text(
                            song.artist,
                            style: const TextStyle(color: Colors.white60),
                            overflow: TextOverflow.ellipsis,
                          ),

                          trailing: isCurrent
                              ? const Icon(
                                  Icons.equalizer,
                                  color: Colors.deepPurpleAccent,
                                )
                              : null,

                          onTap: () async {
                            await player.seek(Duration.zero, index: index);

                            await player.play();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 71, 158, 230),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.queue_music, color: Colors.white),
            onPressed: () => _showQueue(context),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Album art
            StreamBuilder<SequenceState?>(
              stream: player.sequenceStateStream,
              builder: (context, snapshot) {
                final song = snapshot.data?.currentSource?.tag as Song?;
                return Container(
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
                  child: song?.albumArtUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            song!.albumArtUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, er, stack) => const Icon(
                              Icons.music_note,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.music_note,
                          size: 100,
                          color: Colors.white,
                        ),
                );
              },
            ),
            const SizedBox(height: 40),

            // Song info
            StreamBuilder<SequenceState?>(
              stream: player.sequenceStateStream,
              builder: (context, snapshot) {
                final song = snapshot.data?.currentSource?.tag as Song?;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song?.title ?? "Not Playing",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
                        if (song != null)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              song.sourceType == AudioSourceType.stream
                                  ? "Jellyfin"
                                  : "Local",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
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
