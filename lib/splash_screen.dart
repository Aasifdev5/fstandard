import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'onboarding_main.dart';
import 'utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset("assets/logo.mp4")
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
      });

    _videoController.addListener(() {
      final isFinished =
          _videoController.value.position.inMilliseconds >=
          _videoController.value.duration.inMilliseconds;

      if (isFinished) {
        Navigator.pushReplacement(
          context,
          fadePageRoute(const OnboardingMain()),
        );
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: _videoController.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              )
            : const SizedBox(),
      ),
    );
  }
}
