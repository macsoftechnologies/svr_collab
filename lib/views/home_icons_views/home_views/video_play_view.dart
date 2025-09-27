import 'dart:io';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
import 'package:video_player/video_player.dart';
import '../../../utils/colors.dart';

class VideoPlayView extends StatefulWidget {
  final String videoLink;

  const VideoPlayView({super.key, required this.videoLink});

  @override
  State<StatefulWidget> createState() => _VideoPlayView();
}

class _VideoPlayView extends State<VideoPlayView> {
  YoutubePlayerController? _ytController;
  VideoPlayerController? _videoPlayerController;
  bool isYouTube = false;
  bool isVimeo = false;
  bool isServer = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    final url = widget.videoLink;

    if (url.contains("youtube.com") || url.contains("youtu.be")) {
      // 🔹 YouTube video
      isYouTube = true;
      final videoId = YoutubePlayer.convertUrlToId(url);
      if (videoId != null) {
        _ytController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ),
        );
      }
    } else if (url.contains("vimeo.com")) {
      // 🔹 Vimeo video
      isVimeo = true;
    } else if (url.endsWith(".mp4")) {
      // 🔹 Direct server-hosted video
      isServer = true;
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url))
        ..initialize().then((_) {
          setState(() {
            _isInitialized = true;
          });
          _videoPlayerController!.play();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Class Video"),
      ),
      body: Center(
        child: isYouTube && _ytController != null
            ? YoutubePlayer(
          controller: _ytController!,
          showVideoProgressIndicator: true,
        )
            : isVimeo
            ? VimeoPlayer(
          videoId: _extractVimeoVideoId(widget.videoLink),
        )
            : isServer
            ? _isInitialized
            ? AspectRatio(
          aspectRatio:
          _videoPlayerController!.value.aspectRatio,
          child: VideoPlayer(_videoPlayerController!),
        )
            : const CircularProgressIndicator()
            : const Text("Unsupported video format"),
      ),
      floatingActionButton: isServer && _isInitialized
          ? FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_videoPlayerController!.value.isPlaying) {
              _videoPlayerController!.pause();
            } else {
              _videoPlayerController!.play();
            }
          });
        },
        child: Icon(
          _videoPlayerController!.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
        ),
      )
          : null,
    );
  }

  @override
  void dispose() {
    _ytController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  // Extract Vimeo video ID from the URL
  String _extractVimeoVideoId(String url) {
    final uri = Uri.parse(url);
    return uri.pathSegments.last;
  }
}
