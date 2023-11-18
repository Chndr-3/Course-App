import 'package:chewie/chewie.dart';
import 'package:courseapp/model/curriculum_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import '../provider/course_provider.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({Key? key, required this.curriculumItem}) : super(key: key);
  final CurriculumItem curriculumItem;

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  Future<void> _initializeVideoController() async {
    try {
      if (widget.curriculumItem.isDownloaded) {
        _videoPlayerController = VideoPlayerController.file(
          File(
            '${(await getApplicationDocumentsDirectory()).path}/${widget.curriculumItem.id}.mp4',
          ),
        );

      } else {
        _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(widget.curriculumItem.onlineVideoLink == ""
              ? "https://static.videezy.com/system/resources/previews/000/008/452/original/Dark_Haired_Girl_Pensive_Looks_at_Camera.mp4"
              : "https://static.videezy.com/system/resources/previews/000/008/452/original/Dark_Haired_Girl_Pensive_Looks_at_Camera.mp4"),
        );
      }
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        placeholder: widget.curriculumItem.isDownloaded ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Offline Mode", style: TextStyle(color: Colors.black.withOpacity(0.3)),),
        ) : const SizedBox()
      );
      _videoPlayerController.addListener(() {
        if (mounted) {
          // Check if the widget is still mounted before updating the state
          final position = _videoPlayerController.value.position;
          final duration = _videoPlayerController.value.duration;

          final isCloseToEnd = (duration - position).inSeconds <= 0.2;

          if (isCloseToEnd &&
              position.inMilliseconds != 0 &&
              duration.inMilliseconds != 0) {
            Provider.of<CourseProvider>(context, listen: false)
                .markCurriculumAsCompleted(widget.curriculumItem.id);
          }
        }
      });

      await _videoPlayerController.initialize();
    } catch (e) {
      if (kDebugMode) {
        print("Video player initialization error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _initializeVideoController(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Chewie(controller: _chewieController),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.curriculumItem.title.contains('&#8211;')
                        ? widget.curriculumItem.title
                            .split(' &#8211; ')
                            .removeAt(1)
                        : widget.curriculumItem.title,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            );
          } else {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            );
          }
        });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
