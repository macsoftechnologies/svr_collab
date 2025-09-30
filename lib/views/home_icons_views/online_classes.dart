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

class OnlineClasses extends StatefulWidget {
  final String subjectId;
  const OnlineClasses({super.key, required this.subjectId});

  @override
  State<StatefulWidget> createState() => _OnlineClasses();
}

class _OnlineClasses extends State<OnlineClasses> {
  // Map to store download progress for each video
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

  // Function to get the preferred video URL based on priority rules
  String? _getPreferredVideoUrl(OnlineClassesModel video) {
    // First priority: video_link if it's not empty and not from YouTube
    if (video.videoLink != null &&
        video.videoLink!.isNotEmpty &&
        !_isYouTubeUrl(video.videoLink!)) {
      return video.videoLink;
    }

    // Second priority: other_video_link if it's not empty and not from YouTube
    if (video.otherVideoLink != null &&
        video.otherVideoLink!.isNotEmpty &&
        !_isYouTubeUrl(video.otherVideoLink!)) {
      return video.otherVideoLink;
    }

    // Third priority: video_link even if it's YouTube (if other_video_link is empty or also YouTube)
    if (video.videoLink != null && video.videoLink!.isNotEmpty) {
      return video.videoLink;
    }

    // Fourth priority: other_video_link as last resort
    if (video.otherVideoLink != null && video.otherVideoLink!.isNotEmpty) {
      return video.otherVideoLink;
    }

    return null;
  }

  // Check if URL is from YouTube
  bool _isYouTubeUrl(String url) {
    return url.contains('youtube.com') ||
        url.contains('youtu.be') ||
        url.contains('youtube-nocookie.com');
  }

  // Check if the video can be downloaded (non-YouTube URLs only)
  bool _isDownloadable(OnlineClassesModel video) {
    final preferredUrl = _getPreferredVideoUrl(video);
    return preferredUrl != null && !_isYouTubeUrl(preferredUrl);
  }

  // Check if the video is already downloaded
  Future<String?> _getDownloadedVideoPath(String videoName) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/$videoName.mp4';
      if (await File(filePath).exists()) {
        return filePath;
      } else {
        return null;
      }
    } catch (e) {
      print("Error checking file existence: $e");
      return null;
    }
  }

  // Download the video file and save it locally
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
  final fileName = "$videoName.mp4";
  final videoId = video.videoId ?? "unknown_id";

  setState(() {
    _downloadProgress[videoId] = 0.0;
  });

  try {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String savePath = '${appDocDir.path}/$fileName';

    Dio dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(minutes: 5),
    ));

    int lastProgress = 0;
    int lastReceived = 0;
    DateTime lastTime = DateTime.now();

    await dio.download(
      preferredUrl,
      savePath,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: true,
      ),
      onReceiveProgress: (received, total) {
        if (total != -1) {
          final progress = ((received / total) * 100).toInt();

          // Throttle UI updates: only update every 5%
          if (progress - lastProgress >= 5) {
            lastProgress = progress;
            setState(() {
              _downloadProgress[videoId] = received / total;
            });
          }

          // Debugging: Print download speed (optional)
          final now = DateTime.now();
          final elapsed = now.difference(lastTime).inSeconds;
          if (elapsed >= 1) {
            final speed = ((received - lastReceived) / 1024 / elapsed).toStringAsFixed(2);
            print("Download speed: $speed KB/s");

            lastReceived = received;
            lastTime = now;
          }
        }
      },
    );

    final file = File(savePath);
    if (!await file.exists() || await file.length() == 0) {
      throw Exception("Downloaded file invalid or corrupted");
    }

    setState(() {
      _downloadProgress.remove(videoId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("'$videoName' downloaded successfully!"),
        backgroundColor: Colors.green,
      ),
    );

    print("✅ File downloaded to: $savePath");
  } catch (e) {
    setState(() {
      _downloadProgress.remove(videoId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Download failed: $e"),
        backgroundColor: Colors.red,
      ),
    );

    print("❌ Download error: $e");
  }
}

  // Navigate to video player based on download status and URL type
  void _playVideo(OnlineClassesModel video, String? downloadedPath) {
    final preferredUrl = _getPreferredVideoUrl(video);

    if (preferredUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Video link not available.")),
      );
      return;
    }

    if (downloadedPath != null) {
      // Play downloaded video
      print("Playing downloaded video:sk $downloadedPath");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              DownloadedVideosPage(videoPath: downloadedPath),
        ),
      );
    } else if (_isYouTubeUrl(preferredUrl)) {
      // Play YouTube video online
      print("Playing YouTube video: $preferredUrl");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              VideoPlayView(videoLink: preferredUrl),
        ),
      );
    } else {
      // Play non-YouTube video online
      print("Playing online video: $preferredUrl");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              VideoPlayView(videoLink: preferredUrl),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Online Classes"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      OfflineDownloadPage(subjectId: widget.subjectId),
                ),
              );
            },
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
          } else {
            List<OnlineClassesModel> materials = viewModel.onlineClassesInfo;
            return materials.isEmpty
                ? const Center(child: Text("No Data Found"))
                : Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: materials.length,
                    itemBuilder: (BuildContext context, int index) {
                      final video = materials[index];
                      final preferredUrl = _getPreferredVideoUrl(video);
                      final isDownloadable = _isDownloadable(video);

                      return FutureBuilder<String?>(
                        future: _getDownloadedVideoPath(video.videoName!),
                        builder: (context, snapshot) {
                          final isDownloaded =
                              snapshot.hasData && snapshot.data != null;
                          final downloadProgress =
                          _downloadProgress[video.videoId ?? "unknown_id"];

                          return Card(
                            child: InkWell(
                              onTap: () {
                                _playVideo(video, snapshot.data);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Video icon with YouTube indicator
                                    Column(
                                      children: [
                                        const Icon(Icons.play_circle, size: 30),
                                        // if (preferredUrl != null && _isYouTubeUrl(preferredUrl))
                                        //   Container(
                                        //     margin: const EdgeInsets.only(top: 2),
                                        //     padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                        //     decoration: BoxDecoration(
                                        //       color: Colors.red,
                                        //       borderRadius: BorderRadius.circular(4),
                                        //     ),
                                        //     child: const Text(
                                        //       "YT",
                                        //       style: TextStyle(
                                        //         color: Colors.white,
                                        //         fontSize: 8,
                                        //         fontWeight: FontWeight.bold,
                                        //       ),
                                        //     ),
                                        //   ),
                                      ],
                                    ),

                                    // Video name
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      child: Text(
                                        video.videoName!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    const Spacer(),

                                    // Download progress or status indicator
                                    if (downloadProgress != null)
                                      SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                                value: downloadProgress),
                                            Text(
                                                "${(downloadProgress * 100).toStringAsFixed(0)}%"),
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
                                        const Icon(Icons.cloud,
                                            color: Colors.grey, size: 30,
                                            //tooltip: "YouTube Video - Online Only"
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

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

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  Future<void> _initVideoPlayer() async {
    try {
      final file = File(widget.videoPath);
      if (!await file.exists()) {
        throw Exception("Video file not found");
      }

      _videoPlayerController = VideoPlayerController.file(file);
      await _videoPlayerController.initialize();

      setState(() {
        _isInitialized = true;
      });

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
    setState(() {
      _videoPlayerController.play();
      _isPlaying = true;
    });
  }

  void _pauseVideo() {
    setState(() {
      _videoPlayerController.pause();
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloaded Video'),
      ),
      body: Center(
        child: _isInitialized
            ? AspectRatio(
          aspectRatio: _videoPlayerController.value.aspectRatio,
          child: VideoPlayer(_videoPlayerController),
        )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: _isInitialized
          ? FloatingActionButton(
        onPressed: () {
          if (_isPlaying) {
            _pauseVideo();
          } else {
            _playVideo();
          }
        },
        child: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
        ),
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