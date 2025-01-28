import 'package:aplikasi_elearning/services/video_services.dart';
import 'package:aplikasi_elearning/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final VideoService _videoService = VideoService();
  bool _isLoading = true;
  List<dynamic> _videos = [];
  int _currentPage = 1;
  bool _hasNextPage = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadVideos();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (_hasNextPage) {
        _loadVideos(page: _currentPage + 1);
      }
    }
  }

  Future<void> _loadVideos({int page = 1}) async {
    if (!_hasNextPage && page != 1) return;

    try {
      final data = await _videoService.getVideos(page: page);
      setState(() {
        if (page == 1) {
          _videos = data['data'];
        } else {
          _videos.addAll(data['data']);
        }
        _currentPage = page;
        _hasNextPage = data['next_page_url'] != null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _navigateToVideoPlayer(String title, String youtubeUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          title: title,
          youtubeUrl: youtubeUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Pembelajaran'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadVideos(),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _videos.length + (_hasNextPage ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _videos.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final video = _videos[index];
            final youtubeId = YoutubePlayer.convertUrlToId(video['youtube_url']);
            
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                leading: youtubeId != null 
                  ? Image.network(
                      'https://img.youtube.com/vi/$youtubeId/default.jpg',
                      width: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.video_library);
                      },
                    )
                  : const Icon(Icons.video_library),
                title: Text(video['title']),
                onTap: () => _navigateToVideoPlayer(
                  video['title'],
                  video['youtube_url'],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}