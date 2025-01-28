import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        hideControls: false,
        enableCaption: true,
      ),
    );

    _controller.addListener(_onPlayerStateChange);
  }

  void _onPlayerStateChange() {
    if (_controller.value.isFullScreen != _isFullScreen) {
      setState(() {
        _isFullScreen = _controller.value.isFullScreen;
      });

      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      }
    }
  }

  void _exitFullScreen() {
    setState(() {
      _isFullScreen = false;
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controller.toggleFullScreenMode();
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
    return WillPopScope(
      onWillPop: () async {
        if (_isFullScreen) {
          _exitFullScreen();
          return false;
        }
        return true;
      },
      child: OrientationBuilder(builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: isLandscape
              ? null
              : AppBar(
                  title: Text(widget.title),
                ),
          body: Center(
            child: Container(
              width: isLandscape ? MediaQuery.of(context).size.width : null,
              height: isLandscape ? MediaQuery.of(context).size.height : null,
              color: Colors.black,
              child: Stack(
                children: [
                  Center(
                    child: YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      progressColors: const ProgressBarColors(
                        playedColor: Colors.red,
                        handleColor: Colors.redAccent,
                      ),
                      onEnded: (metaData) {
                        if (_isFullScreen) {
                          _exitFullScreen();
                        }
                      },
                    ),
                  ),
                  if (!isLandscape)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _seekBackward,
                            icon: const Icon(Icons.replay_10,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            onPressed: _seekForward,
                            icon: const Icon(Icons.forward_10,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  if (isLandscape)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: GestureDetector(
                        onTap: _exitFullScreen,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.fullscreen_exit,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _controller.removeListener(_onPlayerStateChange);
    _controller.dispose();
    super.dispose();
  }
}
