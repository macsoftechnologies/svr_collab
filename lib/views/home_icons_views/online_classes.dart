// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:svr/models/home_icons_models/online_classes_model.dart';
// import 'package:svr/view_models/home_icons_view_models/online_classes_view_model.dart';
// import 'package:svr/views/home_icons_views/offline_download_page.dart';
// import 'package:svr/utils/colors.dart';
// import 'package:video_player/video_player.dart';
// import 'package:path_provider/path_provider.dart';

// import 'home_views/video_play_view.dart';

// class OnlineClasses extends StatefulWidget {
//   final String subjectId;
//   const OnlineClasses({super.key, required this.subjectId});

//   @override
//   State<StatefulWidget> createState() => _OnlineClasses();
// }

// class _OnlineClasses extends State<OnlineClasses> {
//   // Map to store download progress for each video
//   final Map<String, double> _downloadProgress = {};

//   @override
//   void initState() {
//     super.initState();
//     print("Subject ID: ${widget.subjectId}");

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<OnlineClassesViewModel>(context, listen: false)
//           .fetchOnlineClasses(widget.subjectId, context);
//     });
//   }

//   // Function to get the preferred video URL based on priority rules
//   String? _getPreferredVideoUrl(OnlineClassesModel video) {
//     if (video.videoLink != null &&
//         video.videoLink!.isNotEmpty &&
//         !_isYouTubeUrl(video.videoLink!)) {
//       return video.videoLink;
//     }
//     if (video.otherVideoLink != null &&
//         video.otherVideoLink!.isNotEmpty &&
//         !_isYouTubeUrl(video.otherVideoLink!)) {
//       return video.otherVideoLink;
//     }
//     if (video.videoLink != null && video.videoLink!.isNotEmpty) {
//       return video.videoLink;
//     }
//     if (video.otherVideoLink != null && video.otherVideoLink!.isNotEmpty) {
//       return video.otherVideoLink;
//     }
//     return null;
//   }

//   bool _isYouTubeUrl(String url) {
//     return url.contains('youtube.com') ||
//         url.contains('youtu.be') ||
//         url.contains('youtube-nocookie.com');
//   }

//   bool _isDownloadable(OnlineClassesModel video) {
//     final preferredUrl = _getPreferredVideoUrl(video);
//     return preferredUrl != null && !_isYouTubeUrl(preferredUrl);
//   }

//   Future<String?> _getDownloadedVideoPath(String videoName) async {
//     try {
//       Directory appDocDir = await getApplicationDocumentsDirectory();
//       String filePath = '${appDocDir.path}/$videoName.mp4';
//       if (await File(filePath).exists()) {
//         return filePath;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print("Error checking file existence: $e");
//       return null;
//     }
//   }

//   Future<void> _downloadVideo(OnlineClassesModel video) async {
//     final preferredUrl = _getPreferredVideoUrl(video);
//     if (preferredUrl == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("No valid video URL found for download"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     final videoName = video.videoName ?? "UnknownVideo";
//     final fileName = "$videoName.mp4";
//     final videoId = video.videoId ?? "unknown_id";

//     setState(() {
//       _downloadProgress[videoId] = 0.0;
//     });

//     try {
//       final Directory appDocDir = await getApplicationDocumentsDirectory();
//       final String savePath = '${appDocDir.path}/$fileName';

//       Dio dio = Dio(BaseOptions(
//         connectTimeout: const Duration(seconds: 10),
//         receiveTimeout: const Duration(minutes: 5),
//       ));

//       int lastProgress = 0;
//       int lastReceived = 0;
//       DateTime lastTime = DateTime.now();

//       await dio.download(
//         preferredUrl,
//         savePath,
//         options: Options(
//           responseType: ResponseType.bytes,
//           followRedirects: true,
//         ),
//         onReceiveProgress: (received, total) {
//           if (total != -1) {
//             final progress = ((received / total) * 100).toInt();

//             if (progress - lastProgress >= 5) {
//               lastProgress = progress;
//               setState(() {
//                 _downloadProgress[videoId] = received / total;
//               });
//             }

//             final now = DateTime.now();
//             final elapsed = now.difference(lastTime).inSeconds;
//             if (elapsed >= 1) {
//               final speed =
//                   ((received - lastReceived) / 1024 / elapsed).toStringAsFixed(2);
//               print("Download speed: $speed KB/s");

//               lastReceived = received;
//               lastTime = now;
//             }
//           }
//         },
//       );

//       final file = File(savePath);
//       if (!await file.exists() || await file.length() == 0) {
//         throw Exception("Downloaded file invalid or corrupted");
//       }

//       setState(() {
//         _downloadProgress.remove(videoId);
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("'$videoName' downloaded successfully!"),
//           backgroundColor: Colors.green,
//         ),
//       );

//       print("✅ File downloaded to: $savePath");
//     } catch (e) {
//       setState(() {
//         _downloadProgress.remove(videoId);
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Download failed: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );

//       print("❌ Download error: $e");
//     }
//   }

//   void _playVideo(OnlineClassesModel video, String? downloadedPath) {
//     final preferredUrl = _getPreferredVideoUrl(video);

//     if (preferredUrl == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Video link not available.")),
//       );
//       return;
//     }

//     if (downloadedPath != null) {
//       print("Playing downloaded video: $downloadedPath");
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (BuildContext context) =>
//               DownloadedVideosPage(videoPath: downloadedPath),
//         ),
//       );
//     } else if (_isYouTubeUrl(preferredUrl)) {
//       print("Playing YouTube video: $preferredUrl");
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (BuildContext context) =>
//               VideoPlayView(videoLink: preferredUrl),
//         ),
//       );
//     } else {
//       print("Playing online video: $preferredUrl");
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (BuildContext context) =>
//               VideoPlayView(videoLink: preferredUrl),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: secondaryColor,
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: const Text("Online Classes"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (BuildContext context) =>
//                       OfflineDownloadPage(subjectId: widget.subjectId),
//                 ),
//               );
//             },
//             child: const Text(
//               "Downloads",
//               style: TextStyle(color: Colors.white, fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//       body: Consumer<OnlineClassesViewModel>(
//         builder: (context, viewModel, child) {
//           if (viewModel.fetchingData) {
//             return const Center(child: CircularProgressIndicator());
//           } else {
//             List<OnlineClassesModel> materials = viewModel.onlineClassesInfo;
//             return materials.isEmpty
//                 ? const Center(child: Text("No Data Found"))
//                 : Column(
//                     children: [
//                       Flexible(
//                         child: ListView.builder(
//                           itemCount: materials.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             final video = materials[index];
//                             final preferredUrl = _getPreferredVideoUrl(video);
//                             final isDownloadable = _isDownloadable(video);

//                             return FutureBuilder<String?>(
//                               future: _getDownloadedVideoPath(video.videoName!),
//                               builder: (context, snapshot) {
//                                 final isDownloaded =
//                                     snapshot.hasData && snapshot.data != null;
//                                 final downloadProgress =
//                                     _downloadProgress[video.videoId ?? "unknown_id"];

//                                 return Card(
//                                   child: InkWell(
//                                     onTap: () {
//                                       _playVideo(video, snapshot.data);
//                                     },
//                                     child: Container(
//                                       padding: const EdgeInsets.all(10),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Column(
//                                             children: const [
//                                               Icon(Icons.play_circle, size: 30),
//                                             ],
//                                           ),
//                                           SizedBox(
//                                             width: MediaQuery.of(context).size.width *
//                                                 0.5,
//                                             child: Text(
//                                               video.videoName!,
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 18),
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ),
//                                           const Spacer(),
//                                           if (downloadProgress != null)
//                                             SizedBox(
//                                               width: 50,
//                                               height: 50,
//                                               child: Stack(
//                                                 alignment: Alignment.center,
//                                                 children: [
//                                                   CircularProgressIndicator(
//                                                       value: downloadProgress),
//                                                   Text(
//                                                       "${(downloadProgress * 100).toStringAsFixed(0)}%"),
//                                                 ],
//                                               ),
//                                             )
//                                           else if (isDownloaded)
//                                             const Icon(Icons.check_circle,
//                                                 color: Colors.green, size: 30)
//                                           else if (isDownloadable)
//                                             IconButton(
//                                               icon: const Icon(Icons.download),
//                                               onPressed: () => _downloadVideo(video),
//                                               tooltip: "Download Video",
//                                             )
//                                           else
//                                             const Icon(Icons.online_prediction,
//                                                 color: Colors.grey,
//                                                 size: 30,
//                                                 //tooltip: "YouTube Video - Online Only"
//                                                 ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//           }
//         },
//       ),
//     );
//   }
// }

// class DownloadedVideosPage extends StatefulWidget {
//   final String videoPath;

//   const DownloadedVideosPage({super.key, required this.videoPath});

//   @override
//   _DownloadedVideosPageState createState() => _DownloadedVideosPageState();
// }

// class _DownloadedVideosPageState extends State<DownloadedVideosPage> {
//   late VideoPlayerController _videoPlayerController;
//   bool _isInitialized = false;
//   bool _isPlaying = false;
//   double _currentPosition = 0.0;
//   double _videoDuration = 0.0;
//   double _playbackSpeed = 1.0;

//   @override
//   void initState() {
//     super.initState();
//     _initVideoPlayer();
//   }

//   Future<void> _initVideoPlayer() async {
//     try {
//       final file = File(widget.videoPath);
//       if (!await file.exists()) {
//         throw Exception("Video file not found");
//       }

//       _videoPlayerController = VideoPlayerController.file(file);
//       await _videoPlayerController.initialize();

//       _videoDuration =
//           _videoPlayerController.value.duration.inMilliseconds.toDouble();

//       _videoPlayerController.addListener(() {
//         final position =
//             _videoPlayerController.value.position.inMilliseconds.toDouble();
//         if (mounted) {
//           setState(() {
//             _currentPosition = position;
//           });
//         }
//       });

//       setState(() {
//         _isInitialized = true;
//       });

//       _playVideo();
//     } catch (e) {
//       print("Error initializing video player: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Failed to play video. File may be corrupted."),
//             backgroundColor: Colors.red,
//           ),
//         );
//         Navigator.pop(context);
//       }
//     }
//   }

//   void _playVideo() {
//     _videoPlayerController.setPlaybackSpeed(_playbackSpeed);
//     _videoPlayerController.play();
//     setState(() {
//       _isPlaying = true;
//     });
//   }

//   void _pauseVideo() {
//     _videoPlayerController.pause();
//     setState(() {
//       _isPlaying = false;
//     });
//   }

//   void _changePlaybackSpeed(double speed) {
//     setState(() {
//       _playbackSpeed = speed;
//     });
//     _videoPlayerController.setPlaybackSpeed(speed);
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Downloaded Video'),
//       ),
//       body: Center(
//         child: _isInitialized
//             ? Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   AspectRatio(
//                     aspectRatio: _videoPlayerController.value.aspectRatio,
//                     child: VideoPlayer(_videoPlayerController),
//                   ),
//                   const SizedBox(height: 16, ),
//                   // Progress Slider
//                   Row(
//                     children: [
//                       Text(_formatDuration(_videoPlayerController.value.position)),
//                       Expanded(
//                         child: Slider(
//                           value: _currentPosition,
//                           max: _videoDuration,
//                           min: 0,
//                           onChanged: (value) {
//                             setState(() {
//                               _currentPosition = value;
//                             });
//                           },
//                           onChangeEnd: (value) {
//                             _videoPlayerController
//                                 .seekTo(Duration(milliseconds: value.toInt()));
//                           },
//                         ),
//                       ),
//                       Text(_formatDuration(_videoPlayerController.value.duration)),
//                     ],
//                   ),
//                   // Playback Speed Controls
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       for (var speed in [0.5, 1.0, 1.5, 2.0])
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: ElevatedButton(
//                             onPressed: () => _changePlaybackSpeed(speed),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor:
//                                   _playbackSpeed == speed ? Colors.blue : Colors.grey,
//                             ),
//                             child: Text("${speed}x"),
//                           ),
//                         )
//                     ],
//                   ),
//                 ],
//               )
//             : const CircularProgressIndicator(),
//       ),
//       floatingActionButton: _isInitialized
//           ? FloatingActionButton(
//               onPressed: () {
//                 if (_isPlaying) {
//                   _pauseVideo();
//                 } else {
//                   _playVideo();
//                 }
//               },
//               child: Icon(
//                 _isPlaying ? Icons.pause : Icons.play_arrow,
//               ),
//             )
//           : null,
//     );
//   }

//   @override
//   void dispose() {
//     _videoPlayerController.dispose();
//     super.dispose();
//   }
// }


import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svr/models/home_icons_models/online_classes_model.dart';
import 'package:svr/view_models/home_icons_view_models/online_classes_view_model.dart';
import 'package:svr/views/home_icons_views/offline_download_page.dart';
import 'package:svr/utils/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

import 'home_views/video_play_view.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Download Progress Dialog
// ─────────────────────────────────────────────────────────────────────────────

class _DownloadProgressDialog extends StatefulWidget {
  final String videoName;
  final Stream<_DownloadEvent> eventStream;
  final VoidCallback onBackgroundPressed;

  const _DownloadProgressDialog({
    required this.videoName,
    required this.eventStream,
    required this.onBackgroundPressed,
  });

  @override
  State<_DownloadProgressDialog> createState() =>
      _DownloadProgressDialogState();
}

enum _DownloadStatus { downloading, completed, failed }

class _DownloadEvent {
  final _DownloadStatus status;
  final double progress; // 0.0 – 1.0
  final String? errorMessage;

  const _DownloadEvent({
    required this.status,
    this.progress = 0.0,
    this.errorMessage,
  });
}

class _DownloadProgressDialogState extends State<_DownloadProgressDialog> {
  double _progress = 0.0;
  _DownloadStatus _status = _DownloadStatus.downloading;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    widget.eventStream.listen((event) {
      if (!mounted) return;
      setState(() {
        _progress = event.progress;
        _status = event.status;
        _errorMessage = event.errorMessage;
      });

      // Auto-close on success after a brief delay so user sees "Done!"
      if (event.status == _DownloadStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.of(context).pop();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDone = _status == _DownloadStatus.completed;
    final bool isFailed = _status == _DownloadStatus.failed;
    final bool isDownloading = _status == _DownloadStatus.downloading;

    return WillPopScope(
      // Prevent back-button dismiss while actively downloading
      onWillPop: () async => !isDownloading,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon ──────────────────────────────────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isFailed
                  ? const Icon(Icons.error_outline,
                      key: ValueKey('error'), color: Colors.red, size: 48)
                  : isDone
                      ? const Icon(Icons.check_circle_outline,
                          key: ValueKey('done'), color: Colors.green, size: 48)
                      : const Icon(Icons.download_rounded,
                          key: ValueKey('dl'), color: Colors.blue, size: 48),
            ),
            const SizedBox(height: 12),

            // ── Title ─────────────────────────────────────────────────────────
            Text(
              isFailed
                  ? 'Download Failed'
                  : isDone
                      ? 'Download Complete!'
                      : 'Downloading…',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),

            // ── Video name ────────────────────────────────────────────────────
            Text(
              widget.videoName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 16),

            // ── Progress bar ──────────────────────────────────────────────────
            if (!isFailed) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: isDone ? 1.0 : _progress,
                  minHeight: 10,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDone ? Colors.green : Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isDone
                    ? '100%'
                    : '${(_progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ],

            // ── Error message ─────────────────────────────────────────────────
            if (isFailed && _errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],

            const SizedBox(height: 20),

            // ── Actions ───────────────────────────────────────────────────────
            if (isDownloading)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        widget.onBackgroundPressed();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.minimize_rounded, size: 16),
                      label: const Text('Download Background'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),

            if (isFailed)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Close',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// OnlineClasses Page
// ─────────────────────────────────────────────────────────────────────────────

class OnlineClasses extends StatefulWidget {
  final String subjectId;
  const OnlineClasses({super.key, required this.subjectId});

  @override
  State<StatefulWidget> createState() => _OnlineClasses();
}

class _OnlineClasses extends State<OnlineClasses> {
  /// Tracks UI progress per video (for the card indicator)
  final Map<String, double> _downloadProgress = {};

  @override
  void initState() {
    super.initState();
    print("Subject ID: ${widget.subjectId}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OnlineClassesViewModel>(context, listen: false)
          .fetchOnlineClasses(widget.subjectId, context);
    });
  }

  // ── URL helpers ──────────────────────────────────────────────────────────

  String? _getPreferredVideoUrl(OnlineClassesModel video) {
    if (video.videoLink != null &&
        video.videoLink!.isNotEmpty &&
        !_isYouTubeUrl(video.videoLink!)) {
      return video.videoLink;
    }
    if (video.otherVideoLink != null &&
        video.otherVideoLink!.isNotEmpty &&
        !_isYouTubeUrl(video.otherVideoLink!)) {
      return video.otherVideoLink;
    }
    if (video.videoLink != null && video.videoLink!.isNotEmpty) {
      return video.videoLink;
    }
    if (video.otherVideoLink != null && video.otherVideoLink!.isNotEmpty) {
      return video.otherVideoLink;
    }
    return null;
  }

  bool _isYouTubeUrl(String url) =>
      url.contains('youtube.com') ||
      url.contains('youtu.be') ||
      url.contains('youtube-nocookie.com');

  bool _isDownloadable(OnlineClassesModel video) {
    final url = _getPreferredVideoUrl(video);
    return url != null && !_isYouTubeUrl(url);
  }

  Future<String?> _getDownloadedVideoPath(String videoName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/$videoName.mp4';
      return await File(path).exists() ? path : null;
    } catch (e) {
      print("Error checking file: $e");
      return null;
    }
  }

  // ── Download with progress dialog ─────────────────────────────────────────

  Future<void> _downloadVideo(OnlineClassesModel video) async {
    final preferredUrl = _getPreferredVideoUrl(video);
    if (preferredUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No valid video URL found for download"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final videoName = video.videoName ?? "UnknownVideo";
    final videoId = video.videoId ?? "unknown_id";

    // Stream controller to push events into the dialog
    final controller = StreamController<_DownloadEvent>.broadcast();

    // Whether the dialog has been dismissed (background mode)
    bool dialogDismissed = false;

    // Show the progress dialog immediately
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _DownloadProgressDialog(
        videoName: videoName,
        eventStream: controller.stream,
        onBackgroundPressed: () {
          dialogDismissed = true;
        },
      ),
    );

    // Update card-level indicator
    setState(() => _downloadProgress[videoId] = 0.0);

    try {
      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/$videoName.mp4';

      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(minutes: 10),
      ));

      int lastProgress = 0;

      await dio.download(
        preferredUrl,
        savePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
        onReceiveProgress: (received, total) {
          if (total <= 0) return;

          final ratio = received / total;
          final percent = (ratio * 100).toInt();

          // Push to dialog every 1 %
          if (percent - lastProgress >= 1) {
            lastProgress = percent;
            controller.add(_DownloadEvent(
              status: _DownloadStatus.downloading,
              progress: ratio,
            ));
          }

          // Update card indicator every 5 %
          if (percent % 5 == 0 && mounted) {
            setState(() => _downloadProgress[videoId] = ratio);
          }
        },
      );

      // Validate file
      final file = File(savePath);
      if (!await file.exists() || await file.length() == 0) {
        throw Exception("Downloaded file is invalid or corrupted");
      }

      // Signal completion
      controller.add(const _DownloadEvent(
        status: _DownloadStatus.completed,
        progress: 1.0,
      ));

      setState(() => _downloadProgress.remove(videoId));

      // If dialog was dismissed (background mode), show snackbar instead
      if (dialogDismissed && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("'$videoName' downloaded successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }

      print("✅ Downloaded to: $savePath");
    } catch (e) {
      controller.add(_DownloadEvent(
        status: _DownloadStatus.failed,
        errorMessage: e.toString(),
      ));

      setState(() => _downloadProgress.remove(videoId));

      if (dialogDismissed && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Download failed: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }

      print("❌ Download error: $e");
    } finally {
      await controller.close();
    }
  }

  // ── Play video ────────────────────────────────────────────────────────────

  void _playVideo(OnlineClassesModel video, String? downloadedPath) {
    final preferredUrl = _getPreferredVideoUrl(video);

    if (preferredUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Video link not available.")),
      );
      return;
    }

    if (downloadedPath != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DownloadedVideosPage(videoPath: downloadedPath),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoPlayView(videoLink: preferredUrl),
        ),
      );
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Online Classes"),
        actions: [
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    OfflineDownloadPage(subjectId: widget.subjectId),
              ),
            ),
            child: const Text(
              "Downloads",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Consumer<OnlineClassesViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.fetchingData) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<OnlineClassesModel> materials =
              viewModel.onlineClassesInfo;

          if (materials.isEmpty) {
            return const Center(child: Text("No Data Found"));
          }

          return ListView.builder(
            itemCount: materials.length,
            itemBuilder: (context, index) {
              final video = materials[index];
              final isDownloadable = _isDownloadable(video);
              final videoId = video.videoId ?? "unknown_id";

              return FutureBuilder<String?>(
                future: _getDownloadedVideoPath(video.videoName!),
                builder: (context, snapshot) {
                  final isDownloaded =
                      snapshot.hasData && snapshot.data != null;
                  final downloadProgress = _downloadProgress[videoId];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    child: InkWell(
                      onTap: () => _playVideo(video, snapshot.data),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            // Play icon
                            const Icon(Icons.play_circle,
                                size: 30, color: Colors.blue),
                            const SizedBox(width: 10),

                            // Video name
                            Expanded(
                              child: Text(
                                video.videoName!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Right-side status widget
                            if (downloadProgress != null)
                              // Card-level mini progress ring (background mode)
                              SizedBox(
                                width: 44,
                                height: 44,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: downloadProgress,
                                      strokeWidth: 3,
                                    ),
                                    Text(
                                      "${(downloadProgress * 100).toStringAsFixed(0)}%",
                                      style: const TextStyle(fontSize: 9),
                                    ),
                                  ],
                                ),
                              )
                            else if (isDownloaded)
                              const Icon(Icons.check_circle,
                                  color: Colors.green, size: 30)
                            else if (isDownloadable)
                              IconButton(
                                icon: const Icon(Icons.download),
                                onPressed: () => _downloadVideo(video),
                                tooltip: "Download Video",
                              )
                            else
                              const Icon(Icons.online_prediction,
                                  color: Colors.grey, size: 30),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Downloaded Video Player (unchanged logic, minor cleanup)
// ─────────────────────────────────────────────────────────────────────────────

class DownloadedVideosPage extends StatefulWidget {
  final String videoPath;
  const DownloadedVideosPage({super.key, required this.videoPath});

  @override
  _DownloadedVideosPageState createState() => _DownloadedVideosPageState();
}

class _DownloadedVideosPageState extends State<DownloadedVideosPage> {
  late VideoPlayerController _videoPlayerController;
  bool _isInitialized = false;
  bool _isPlaying = false;
  double _currentPosition = 0.0;
  double _videoDuration = 0.0;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  Future<void> _initVideoPlayer() async {
    try {
      final file = File(widget.videoPath);
      if (!await file.exists()) throw Exception("Video file not found");

      _videoPlayerController = VideoPlayerController.file(file);
      await _videoPlayerController.initialize();
      _videoDuration =
          _videoPlayerController.value.duration.inMilliseconds.toDouble();

      _videoPlayerController.addListener(() {
        if (mounted) {
          setState(() {
            _currentPosition = _videoPlayerController
                .value.position.inMilliseconds
                .toDouble();
          });
        }
      });

      setState(() => _isInitialized = true);
      _playVideo();
    } catch (e) {
      print("Error initializing video player: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to play video. File may be corrupted."),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  void _playVideo() {
    _videoPlayerController.setPlaybackSpeed(_playbackSpeed);
    _videoPlayerController.play();
    setState(() => _isPlaying = true);
  }

  void _pauseVideo() {
    _videoPlayerController.pause();
    setState(() => _isPlaying = false);
  }

  void _changePlaybackSpeed(double speed) {
    setState(() => _playbackSpeed = speed);
    _videoPlayerController.setPlaybackSpeed(speed);
  }

  String _formatDuration(Duration d) {
    String pad(int n) => n.toString().padLeft(2, '0');
    return "${pad(d.inHours)}:${pad(d.inMinutes.remainder(60))}:${pad(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Downloaded Video')),
      body: Center(
        child: _isInitialized
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(_formatDuration(
                          _videoPlayerController.value.position)),
                      Expanded(
                        child: Slider(
                          value: _currentPosition,
                          max: _videoDuration,
                          min: 0,
                          onChanged: (v) =>
                              setState(() => _currentPosition = v),
                          onChangeEnd: (v) => _videoPlayerController
                              .seekTo(Duration(milliseconds: v.toInt())),
                        ),
                      ),
                      Text(_formatDuration(
                          _videoPlayerController.value.duration)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var speed in [0.5, 1.0, 1.5, 2.0])
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                            onPressed: () => _changePlaybackSpeed(speed),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _playbackSpeed == speed
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            child: Text("${speed}x"),
                          ),
                        ),
                    ],
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: _isInitialized
          ? FloatingActionButton(
              onPressed: _isPlaying ? _pauseVideo : _playVideo,
              child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            )
          : null,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}