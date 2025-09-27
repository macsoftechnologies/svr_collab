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

  // Load all downloaded video files from the app's internal storage
  Future<void> _loadDownloadedFiles() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final List<FileSystemEntity> files = appDocDir.listSync();

      // Filter only .mp4 files and convert to File objects
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error loading downloaded videos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to delete the video file from local storage
  Future<void> _deleteVideo(File videoFile) async {
    try {
      if (await videoFile.exists()) {
        await videoFile.delete();

        // Verify the file is actually deleted
        if (!await videoFile.exists()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('"${_getFileName(videoFile)}" deleted successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Remove from list and update UI
          setState(() {
            _downloadedFiles.removeWhere((file) => file.path == videoFile.path);
          });
        } else {
          throw Exception("File still exists after deletion attempt");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Video file not found'),
            backgroundColor: Colors.red,
          ),
        );
        // Refresh list since file doesn't exist
        _loadDownloadedFiles();
      }
    } catch (e) {
      print("Error deleting video: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete video: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );

      // Refresh list to ensure consistency
      _loadDownloadedFiles();
    }
  }

  // Show confirmation dialog before deletion
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
              onPressed: () {
                Navigator.of(context).pop();
              },
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

  // Get file name without extension
  String _getFileName(File file) {
    try {
      String fileName = file.path.split('/').last;
      return fileName.replaceAll('.mp4', '');
    } catch (e) {
      return 'Unknown Video';
    }
  }

  // Get file size in readable format
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
  bool _isPlaying = true;
  bool _isFullScreen = false;
  bool _isInitialized = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      final file = File(widget.filePath);

      // Check if file exists before initializing
      if (!await file.exists()) {
        _showErrorAndGoBack('Video file not found');
        return;
      }

      _controller = VideoPlayerController.file(file)
        ..addListener(() {
          if (_controller.value.hasError) {
            print("Video player error: ${_controller.value.errorDescription}");
          }
        });

      await _controller.initialize();

      setState(() {
        _isInitialized = true;
        _isLoading = false;
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

  // Toggle play/pause functionality
  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  // Toggle full-screen functionality
  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        // Lock orientation to landscape
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft
        ]);
      } else {
        // Reset orientation back to portrait
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown
        ]);
      }
    });
  }

  // Handle back press to stop video and dispose the controller
  Future<bool> _onWillPop() async {
    // Reset orientation when leaving the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    // Pause the video
    if (_isPlaying) {
      await _controller.pause();
    }

    // Dispose the controller
    _controller.dispose();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _isFullScreen ? null : AppBar(
          title: const Text("Video Player"),
          backgroundColor: Colors.black,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _isInitialized
            ? Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
            // Play/Pause button
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
                  ),
                  onPressed: _togglePlayPause,
                ),
              ),
            ),
            // Full-screen button
            if (!_isFullScreen)
              Positioned(
                bottom: 20,
                right: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: _toggleFullScreen,
                ),
              ),
            // Exit full-screen button (shown only in full-screen mode)
            if (_isFullScreen)
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.fullscreen_exit,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: _toggleFullScreen,
                ),
              ),
          ],
        )
            : const Center(
          child: Text(
            "Failed to load video",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    // Ensure orientation is reset when widget is disposed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    super.dispose();
  }
}