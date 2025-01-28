import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String title;
  final String youtubeUrl;

  const VideoPlayerScreen({
    Key? key,
    required this.title,
    required this.youtubeUrl,
  }) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  void _seekBackward() {
    final currentPosition = _controller.value.position;
    if (currentPosition.inSeconds - 10 > 0) {
      _controller.seekTo(currentPosition - const Duration(seconds: 10));
    }
  }

  void _seekForward() {
    final currentPosition = _controller.value.position;
    final duration = _controller.metadata.duration;
    if (currentPosition.inSeconds + 10 < duration.inSeconds) {
      _controller.seekTo(currentPosition + const Duration(seconds: 10));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressColors: const ProgressBarColors(
              playedColor: Colors.red,
              handleColor: Colors.redAccent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _seekBackward,
                  icon: const Icon(Icons.replay_10),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: _seekForward,
                  icon: const Icon(Icons.forward_10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}