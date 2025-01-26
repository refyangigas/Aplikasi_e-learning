import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:aplikasi_elearning/services/video_services.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);
  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final VideoService _service = VideoService();
  List<VideoModel> _videos = [];
  Map<int, YoutubePlayerController> _controllers = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadVideos() async {
    try {
      final videos = await _service.getVideos();
      
      setState(() {
        _videos = videos;
        for (var video in videos) {
          final videoId = YoutubePlayer.convertUrlToId(video.youtubeUrl);
          if (videoId != null) {
            _controllers[video.id] = YoutubePlayerController(
              initialVideoId: videoId,
              flags: const YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
                showLiveFullscreenButton: true,
              ),
            );
          }
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Pembelajaran'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            ElevatedButton(
              onPressed: _loadVideos,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_videos.isEmpty) {
      return const Center(child: Text('Tidak ada video tersedia'));
    }

    return ListView.builder(
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        final video = _videos[index];
        final controller = _controllers[video.id];
        
        if (controller == null) return const SizedBox();

        return Card(
          margin: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  video.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.red,
                  progressColors: const ProgressBarColors(
                    playedColor: Colors.red,
                    handleColor: Colors.redAccent,
                  ),
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(isExpanded: true),
                    RemainingDuration(),
                    const PlaybackSpeedButton(),
                  ],
                ),
                builder: (context, player) {
                  return player;
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
