// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // <-- needed for SystemChrome
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
// import 'package:video_player/video_player.dart';
// import '../../../utils/colors.dart';

// class VideoPlayView extends StatefulWidget {
//   final String videoLink;

//   const VideoPlayView({super.key, required this.videoLink});

//   @override
//   State<StatefulWidget> createState() => _VideoPlayView();
// }

// class _VideoPlayView extends State<VideoPlayView> {
//   YoutubePlayerController? _ytController;
//   VideoPlayerController? _videoPlayerController;
//   bool isYouTube = false;
//   bool isVimeo = false;
//   bool isServer = false;
//   bool _isInitialized = false;

//   @override
//   void initState() {
//     super.initState();

//     final url = widget.videoLink;

//     if (url.contains("youtube.com") || url.contains("youtu.be")) {
//       isYouTube = true;
//       final videoId = YoutubePlayer.convertUrlToId(url);
//       if (videoId != null) {
//         _ytController = YoutubePlayerController(
//           initialVideoId: videoId,
//           flags: const YoutubePlayerFlags(
//             autoPlay: true,
//             mute: false,
//           ),
//         );
//       }
//     } else if (url.contains("vimeo.com")) {
//       isVimeo = true;
//     } else if (url.endsWith(".mp4")) {
//       isServer = true;
//       _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url))
//         ..initialize().then((_) {
//           setState(() {
//             _isInitialized = true;
//           });
//           _videoPlayerController!.play();
//         });
//     }
//   }

//   void _enterFullScreen() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => FullScreenVideoPlayer(
//           videoPlayerController: _videoPlayerController!,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: const Text("Class Video"),
//       ),
//       body: Center(
//         child: isYouTube && _ytController != null
//             ? YoutubePlayer(
//                 controller: _ytController!,
//                 showVideoProgressIndicator: true,
//                 bottomActions: [
//                   CurrentPosition(),
//                   // Removed ProgressBar here per your request
//                   FullScreenButton(),
//                 ],
//               )
//             : isVimeo
//                 ? VimeoPlayer(
//                     videoId: _extractVimeoVideoId(widget.videoLink),
//                   )
//                 : isServer
//                     ? _isInitialized
//                         ? Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               AspectRatio(
//                                 aspectRatio:
//                                     _videoPlayerController!.value.aspectRatio,
//                                 child: VideoPlayer(_videoPlayerController!),
//                               ),
//                               // Removed VideoProgressIndicator here
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(
//                                       _videoPlayerController!.value.isPlaying
//                                           ? Icons.pause
//                                           : Icons.play_arrow,
//                                     ),
//                                     onPressed: () {
//                                       setState(() {
//                                         if (_videoPlayerController!
//                                             .value.isPlaying) {
//                                           _videoPlayerController!.pause();
//                                         } else {
//                                           _videoPlayerController!.play();
//                                         }
//                                       });
//                                     },
//                                   ),
//                                   Text(
//                                     _formatDuration(
//                                         _videoPlayerController!.value.position),
//                                   ),
//                                   Expanded(
//                                     child: Slider(
//                                       min: 0,
//                                       max: _videoPlayerController!
//                                           .value.duration.inMilliseconds
//                                           .toDouble(),
//                                       value: _videoPlayerController!
//                                           .value.position.inMilliseconds
//                                           .toDouble()
//                                           .clamp(
//                                               0,
//                                               _videoPlayerController!
//                                                   .value.duration
//                                                   .inMilliseconds
//                                                   .toDouble()),
//                                       onChanged: (value) {
//                                         setState(() {
//                                           _videoPlayerController!.seekTo(
//                                             Duration(milliseconds: value.toInt()),
//                                           );
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                   Text(
//                                     _formatDuration(
//                                         _videoPlayerController!.value.duration),
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.fullscreen),
//                                     onPressed: _enterFullScreen,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           )
//                         : const CircularProgressIndicator()
//                     : const Text("Unsupported video format"),
//       ),
//     );
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//   }

//   @override
//   void dispose() {
//     _ytController?.dispose();
//     _videoPlayerController?.dispose();
//     super.dispose();
//   }

//   String _extractVimeoVideoId(String url) {
//     final uri = Uri.parse(url);
//     return uri.pathSegments.last;
//   }
// }

// class FullScreenVideoPlayer extends StatefulWidget {
//   final VideoPlayerController videoPlayerController;

//   const FullScreenVideoPlayer({Key? key, required this.videoPlayerController})
//       : super(key: key);

//   @override
//   State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
// }

// class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = widget.videoPlayerController;
//     _controller.addListener(_onVideoChanged);

//     // Set landscape orientation and fullscreen mode
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
//   }

//   void _onVideoChanged() {
//     if (mounted) setState(() {});
//   }

//   @override
//   void dispose() {
//     // Restore portrait orientation and system UI on exit fullscreen
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

//     _controller.removeListener(_onVideoChanged);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: _controller.value.isInitialized
//             ? Stack(
//                 alignment: Alignment.bottomCenter,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         if (_controller.value.isPlaying) {
//                           _controller.pause();
//                         } else {
//                           _controller.play();
//                         }
//                       });
//                     },
//                     child: AspectRatio(
//                       aspectRatio: _controller.value.aspectRatio,
//                       child: VideoPlayer(_controller),
//                     ),
//                   ),

//                   Positioned(
//                     bottom: 30,
//                     left: 20,
//                     right: 20,
//                     child: Row(
//                       children: [
//                         IconButton(
//                           icon: Icon(
//                             _controller.value.isPlaying
//                                 ? Icons.pause
//                                 : Icons.play_arrow,
//                             color: Colors.black,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               if (_controller.value.isPlaying) {
//                                 _controller.pause();
//                               } else {
//                                 _controller.play();
//                               }
//                             });
//                           },
//                         ),
//                         Text(
//                           _formatDuration(_controller.value.position),
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                         Expanded(
//                           child: Slider(
//                             min: 0,
//                             max: _controller.value.duration.inMilliseconds.toDouble(),
//                             value: _controller.value.position.inMilliseconds.toDouble().clamp(
//                                   0,
//                                   _controller.value.duration.inMilliseconds.toDouble(),
//                                 ),
//                             onChanged: (value) {
//                               setState(() {
//                                 _controller.seekTo(Duration(milliseconds: value.toInt()));
//                               });
//                             },
//                           ),
//                         ),
//                         Text(
//                           _formatDuration(_controller.value.duration),
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.close, color: Colors.white),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               )
//             : const CircularProgressIndicator(),
//       ),
//     );
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//   }
// }

import 'dart:async'; // <-- needed for Timer
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

  // current playback speed for the server (mp4) video
  double _playbackSpeed = 1.0;
  final List<double> _speedOptions = [0.5, 1.0, 2.0];

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

  // Seek forward/backward helper, clamped to video bounds
  void _seekBy(Duration offset) {
    final controller = _videoPlayerController;
    if (controller == null) return;
    final newPosition = controller.value.position + offset;
    final clamped = newPosition < Duration.zero
        ? Duration.zero
        : (newPosition > controller.value.duration
            ? controller.value.duration
            : newPosition);
    controller.seekTo(clamped);
  }

  void _setSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
    });
    _videoPlayerController?.setPlaybackSpeed(speed);
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

                              // Seek + Play/Pause row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.replay_10),
                                    tooltip: "Back 10s",
                                    onPressed: () =>
                                        _seekBy(const Duration(seconds: -10)),
                                  ),
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
                                  IconButton(
                                    icon: const Icon(Icons.forward_10),
                                    tooltip: "Forward 10s",
                                    onPressed: () =>
                                        _seekBy(const Duration(seconds: 10)),
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

                              // Speed control row (0.5x / 1x / 2x)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: _speedOptions.map((speed) {
                                    final isSelected = _playbackSpeed == speed;
                                    return Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 6),
                                      child: ChoiceChip(
                                        label: Text("${speed}x"),
                                        selected: isSelected,
                                        onSelected: (_) => _setSpeed(speed),
                                        selectedColor: primaryColor,
                                        labelStyle: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
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

  double _playbackSpeed = 1.0;
  final List<double> _speedOptions = [0.5, 1.0, 2.0];

  // controls visibility state
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _controller = widget.videoPlayerController;
    _controller.addListener(_onVideoChanged);
    _playbackSpeed = _controller.value.playbackSpeed == 0
        ? 1.0
        : _controller.value.playbackSpeed;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _startHideTimer();
  }

  void _onVideoChanged() {
    if (mounted) setState(() {});
  }

  // Starts/restarts the 3s auto-hide countdown, only while playing
  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (_controller.value.isPlaying && mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  // Tap on video: toggle controls visibility
  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls && _controller.value.isPlaying) {
      _startHideTimer();
    } else {
      _hideTimer?.cancel();
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _showControls = true; // always show controls when paused
        _hideTimer?.cancel();
      } else {
        _controller.play();
        _startHideTimer(); // resume auto-hide once playing again
      }
    });
  }

  // Seek forward/backward helper, clamped to video bounds
  void _seekBy(Duration offset) {
    final newPosition = _controller.value.position + offset;
    final clamped = newPosition < Duration.zero
        ? Duration.zero
        : (newPosition > _controller.value.duration
            ? _controller.value.duration
            : newPosition);
    _controller.seekTo(clamped);
    _startHideTimer();
  }

  void _setSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
    });
    _controller.setPlaybackSpeed(speed);
    _startHideTimer();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    _hideTimer?.cancel();
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
                    onTap: _toggleControls, // tap video shows/hides controls
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),

                  // Center play/pause icon — only when controls visible
                  AnimatedOpacity(
                    opacity: _showControls ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: IgnorePointer(
                      ignoring: !_showControls,
                      child: Center(
                        child: IconButton(
                          iconSize: 56,
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            color: Colors.white70,
                          ),
                          onPressed: _togglePlayPause,
                        ),
                      ),
                    ),
                  ),

                  // Bottom controls — fade in/out based on _showControls
                  Positioned(
                    bottom: 30,
                    left: 20,
                    right: 20,
                    child: AnimatedOpacity(
                      opacity: _showControls ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: IgnorePointer(
                        ignoring: !_showControls,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Speed control row (0.5x / 1x / 2x)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _speedOptions.map((speed) {
                                final isSelected = _playbackSpeed == speed;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6),
                                  child: ChoiceChip(
                                    label: Text(
                                      "${speed}x",
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                    selected: isSelected,
                                    onSelected: (_) => _setSpeed(speed),
                                    selectedColor: Colors.white,
                                    backgroundColor: Colors.black54,
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 8),

                            // Seek + play/pause + progress row
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.replay_10,
                                      color: Colors.white),
                                  tooltip: "Back 10s",
                                  onPressed: () =>
                                      _seekBy(const Duration(seconds: -10)),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                  onPressed: _togglePlayPause,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.forward_10,
                                      color: Colors.white),
                                  tooltip: "Forward 10s",
                                  onPressed: () =>
                                      _seekBy(const Duration(seconds: 10)),
                                ),
                                Text(
                                  _formatDuration(_controller.value.position),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Expanded(
                                  child: Slider(
                                    min: 0,
                                    max: _controller
                                        .value.duration.inMilliseconds
                                        .toDouble(),
                                    value: _controller
                                        .value.position.inMilliseconds
                                        .toDouble()
                                        .clamp(
                                          0,
                                          _controller
                                              .value.duration.inMilliseconds
                                              .toDouble(),
                                        ),
                                    onChanged: (value) {
                                      setState(() {
                                        _controller.seekTo(Duration(
                                            milliseconds: value.toInt()));
                                      });
                                      _startHideTimer();
                                    },
                                  ),
                                ),
                                Text(
                                  _formatDuration(_controller.value.duration),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.white),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
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