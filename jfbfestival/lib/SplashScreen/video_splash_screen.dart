import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:jfbfestival/main.dart'; // adjust the import if needed

class VideoSplashScreen extends StatefulWidget {
  const VideoSplashScreen({super.key});

  @override
  State<VideoSplashScreen> createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/Intro1.mp4')
      ..initialize().then((_) {
        setState(() {}); // Refresh the UI when initialized
        _controller.setVolume(0); // Mute if needed for autoplay
        _controller.play();

        // Navigate after video finishes
        _controller.addListener(() {
  final position = _controller.value.position;
  final duration = _controller.value.duration;

  // End 0.5 seconds early
  if (duration.inMilliseconds > 0 &&
      position.inMilliseconds >= duration.inMilliseconds - 600) {
    _controller.removeListener(() {}); // prevent repeated calls
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    }
  }
});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
