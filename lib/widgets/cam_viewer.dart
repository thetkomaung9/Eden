import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../models/cam_model.dart';

class CamViewer extends StatefulWidget {
  final PublicCam cam;
  const CamViewer({super.key, required this.cam});

  @override
  State<CamViewer> createState() => _CamViewerState();
}

class _CamViewerState extends State<CamViewer> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.cam.videoUrl));
    _videoController.initialize().then((_) {
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoController,
          autoPlay: true,
          isLive: true,
          aspectRatio: 16 / 9,
        );
      });
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
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Text(widget.cam.title,
          style: const TextStyle(color: Colors.greenAccent)),
      content: SizedBox(
        width: double.maxFinite,
        height: 250,
        child: _chewieController != null
            ? Chewie(controller: _chewieController!)
            : const Center(
                child: CircularProgressIndicator(color: Colors.greenAccent)),
      ),
    );
  }
}
