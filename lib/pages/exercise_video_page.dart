import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ExerciseVideoPage extends StatefulWidget {
  final String videoUrl;

  const ExerciseVideoPage({super.key, required this.videoUrl});

  @override
  State<ExerciseVideoPage> createState() => _ExerciseVideoPageState();
}

class _ExerciseVideoPageState extends State<ExerciseVideoPage> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() {
    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

    _videoController.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: true,
        looping: true,
        allowFullScreen: true,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _chewieController == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Chewie(controller: _chewieController!),
            ),
    );
  }
}
