import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- needed for SystemChrome
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
      isVimeo = true;
    } else if (url.endsWith(".mp4")) {
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

  void _enterFullScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(
          videoPlayerController: _videoPlayerController!,
        ),
      ),
    );
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
                bottomActions: [
                  CurrentPosition(),
                  // Removed ProgressBar here per your request
                  FullScreenButton(),
                ],
              )
            : isVimeo
                ? VimeoPlayer(
                    videoId: _extractVimeoVideoId(widget.videoLink),
                  )
                : isServer
                    ? _isInitialized
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AspectRatio(
                                aspectRatio:
                                    _videoPlayerController!.value.aspectRatio,
                                child: VideoPlayer(_videoPlayerController!),
                              ),
                              // Removed VideoProgressIndicator here
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _videoPlayerController!.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (_videoPlayerController!
                                            .value.isPlaying) {
                                          _videoPlayerController!.pause();
                                        } else {
                                          _videoPlayerController!.play();
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    _formatDuration(
                                        _videoPlayerController!.value.position),
                                  ),
                                  Expanded(
                                    child: Slider(
                                      min: 0,
                                      max: _videoPlayerController!
                                          .value.duration.inMilliseconds
                                          .toDouble(),
                                      value: _videoPlayerController!
                                          .value.position.inMilliseconds
                                          .toDouble()
                                          .clamp(
                                              0,
                                              _videoPlayerController!
                                                  .value.duration
                                                  .inMilliseconds
                                                  .toDouble()),
                                      onChanged: (value) {
                                        setState(() {
                                          _videoPlayerController!.seekTo(
                                            Duration(milliseconds: value.toInt()),
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    _formatDuration(
                                        _videoPlayerController!.value.duration),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.fullscreen),
                                    onPressed: _enterFullScreen,
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const CircularProgressIndicator()
                    : const Text("Unsupported video format"),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _ytController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  String _extractVimeoVideoId(String url) {
    final uri = Uri.parse(url);
    return uri.pathSegments.last;
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const FullScreenVideoPlayer({Key? key, required this.videoPlayerController})
      : super(key: key);

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.videoPlayerController;
    _controller.addListener(_onVideoChanged);

    // Set landscape orientation and fullscreen mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void _onVideoChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    // Restore portrait orientation and system UI on exit fullscreen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    _controller.removeListener(_onVideoChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      });
                    },
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),

                  Positioned(
                    bottom: 30,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                              } else {
                                _controller.play();
                              }
                            });
                          },
                        ),
                        Text(
                          _formatDuration(_controller.value.position),
                          style: const TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: Slider(
                            min: 0,
                            max: _controller.value.duration.inMilliseconds.toDouble(),
                            value: _controller.value.position.inMilliseconds.toDouble().clamp(
                                  0,
                                  _controller.value.duration.inMilliseconds.toDouble(),
                                ),
                            onChanged: (value) {
                              setState(() {
                                _controller.seekTo(Duration(milliseconds: value.toInt()));
                              });
                            },
                          ),
                        ),
                        Text(
                          _formatDuration(_controller.value.duration),
                          style: const TextStyle(color: Colors.white),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
