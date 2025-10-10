import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class OfflineDownloadPage extends StatefulWidget {
  final String subjectId;
  const OfflineDownloadPage({super.key, required this.subjectId});

  @override
  State<OfflineDownloadPage> createState() => _OfflineDownloadPageState();
}

class _OfflineDownloadPageState extends State<OfflineDownloadPage> {
  List<File> _downloadedFiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDownloadedFiles();
  }

  Future<void> _loadDownloadedFiles() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final List<FileSystemEntity> files = appDocDir.listSync();

      final List<File> videoFiles = files.where((file) {
        return file is File && file.path.toLowerCase().endsWith('.mp4');
      }).cast<File>().toList();

      setState(() {
        _downloadedFiles = videoFiles;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading downloaded files: $e");
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error loading downloaded videos'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteVideo(File videoFile) async {
    try {
      if (await videoFile.exists()) {
        await videoFile.delete();

        if (!await videoFile.exists()) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('"${_getFileName(videoFile)}" deleted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
          setState(() {
            _downloadedFiles.removeWhere((file) => file.path == videoFile.path);
          });
        } else {
          throw Exception("File still exists after deletion attempt");
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Video file not found'),
              backgroundColor: Colors.red,
            ),
          );
        }
        _loadDownloadedFiles();
      }
    } catch (e) {
      print("Error deleting video: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete video: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      _loadDownloadedFiles();
    }
  }

  Future<void> _showDeleteConfirmationDialog(File videoFile) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Video'),
          content: Text(
            'Are you sure you want to delete "${_getFileName(videoFile)}"?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteVideo(videoFile);
              },
            ),
          ],
        );
      },
    );
  }

  String _getFileName(File file) {
    try {
      String fileName = file.path.split('/').last;
      return fileName.replaceAll('.mp4', '');
    } catch (e) {
      return 'Unknown Video';
    }
  }

  Future<String> _getFileSize(File file) async {
    try {
      final stat = await file.stat();
      final sizeInBytes = stat.size;

      if (sizeInBytes < 1024) {
        return '${sizeInBytes} B';
      } else if (sizeInBytes < 1024 * 1024) {
        return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
      } else {
        return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
      }
    } catch (e) {
      return 'Unknown size';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Offline Videos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDownloadedFiles,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _downloadedFiles.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.video_library,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "No Offline Videos Found",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Download videos from Online Classes to view them here",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadDownloadedFiles,
                  child: ListView.builder(
                    itemCount: _downloadedFiles.length,
                    itemBuilder: (context, index) {
                      final file = _downloadedFiles[index];
                      final videoName = _getFileName(file);

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.video_library, size: 36),
                          title: Text(
                            videoName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: FutureBuilder<String>(
                            future: _getFileSize(file),
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.hasData ? snapshot.data! : 'Loading...',
                              );
                            },
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteConfirmationDialog(file),
                            tooltip: 'Delete Video',
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerScreen(filePath: file.path),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String filePath;

  const VideoPlayerScreen({super.key, required this.filePath});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isFullScreen = false;
  bool _isInitialized = false;
  bool _isLoading = true;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      final file = File(widget.filePath);

      if (!await file.exists()) {
        _showErrorAndGoBack('Video file not found');
        return;
      }

      _controller = VideoPlayerController.file(file)
        ..addListener(() {
          if (_controller.value.hasError) {
            _showErrorAndGoBack('Video player error: ${_controller.value.errorDescription}');
          }
          if (mounted) setState(() {});
        });

      await _controller.initialize();

      setState(() {
        _isInitialized = true;
        _isLoading = false;
        _isPlaying = true;
      });

      _controller.play();
      _controller.setLooping(true);
    } catch (e) {
      print("Error initializing video player: $e");
      _showErrorAndGoBack('Failed to load video: $e');
    }
  }

  void _showErrorAndGoBack(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
      _showControls = true;
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  Future<bool> _onWillPop() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await _controller.pause();
    _controller.dispose();
    return true;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  void _onTapVideo() {
    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _isFullScreen
            ? null
            : AppBar(
                title: const Text("Video Player"),
                backgroundColor: Colors.black,
              ),
        body: GestureDetector(
          onTap: _onTapVideo,
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : _isInitialized
                    ? Stack(
                        children: [
                          Center(
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                          if (_showControls) ...[
                            // Play/pause button overlay
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  
                                  child: IconButton(
                                    iconSize: 64,
                                    icon: Icon(
                                      _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                                      color: Colors.white,
                                    ),
                                    onPressed: _togglePlayPause,
                                  ),
                                ),
                              ),
                            ),
                            // Bottom controls: progress slider, time, fullscreen button
                            Positioned(
                              bottom: 50,
                              left: 10,
                              right: 10,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  VideoProgressSlider(controller: _controller),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatDuration(_controller.value.position),
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                                          color: Colors.white,
                                        ),
                                        onPressed: _toggleFullScreen,
                                      ),
                                      Text(
                                        _formatDuration(_controller.value.duration),
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      )
                    : const Text(
                        "Failed to load video",
                        style: TextStyle(color: Colors.white),
                      ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}

class VideoProgressSlider extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoProgressSlider({super.key, required this.controller});

  @override
  _VideoProgressSliderState createState() => _VideoProgressSliderState();
}

class _VideoProgressSliderState extends State<VideoProgressSlider> {
  double? _currentValue;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateValue);
  }

  void _updateValue() {
    if (!_isDragging && mounted) {
      setState(() {
        _currentValue = widget.controller.value.position.inMilliseconds.toDouble();
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duration = widget.controller.value.duration.inMilliseconds.toDouble();
    final position = _currentValue ?? widget.controller.value.position.inMilliseconds.toDouble();

    return Slider(
      min: 0,
      max: duration > 0 ? duration : 1,
      value: position.clamp(0, duration),
      onChanged: (value) {
        setState(() {
          _currentValue = value;
          _isDragging = true;
        });
      },
      onChangeEnd: (value) {
        widget.controller.seekTo(Duration(milliseconds: value.toInt()));
        setState(() {
          _isDragging = false;
        });
      },
      activeColor: Colors.blueAccent,
      inactiveColor: Colors.white38,
    );
  }
}
