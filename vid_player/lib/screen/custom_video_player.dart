import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/screen/custom_icon_button.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;
  final GestureTapCallback onNewVideoPressed;

  const CustomVideoPlayer({
    required this.video,
    required this.onNewVideoPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoPlayerController;
  bool showControls = false;

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video.path != widget.video.path) {
      videoPlayerController?.removeListener(videoControllerListener);
      initializeController();
    }
  }

  @override
  void initState() {
    super.initState();
    initializeController();
  }

  initializeController() async {
    final videoController = VideoPlayerController.file(File(widget.video.path));

    await videoController.initialize();

    videoController.addListener(videoControllerListener);

    setState(() {
      videoPlayerController = videoController;
    });
  }

  void videoControllerListener() {
    setState(() {});
  }

  @override
  void dispose() {
    videoPlayerController?.removeListener(videoControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (videoPlayerController == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return GestureDetector(
        onTap: () {
          setState(() {
            showControls = !showControls;
          });
        },
        child: AspectRatio(
          aspectRatio: videoPlayerController!.value.aspectRatio,
          child: Stack(
            children: [
              VideoPlayer(
                videoPlayerController!,
              ),
              if(showControls) Container(
                color: Colors.black.withOpacity(0.5),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        renderTimeTextFromDuration(
                          videoPlayerController!.value.position,
                        ),
                        Expanded(
                          child: Slider(
                            onChanged: (double val) {
                              videoPlayerController!
                                  .seekTo(Duration(seconds: val.toInt()));
                            },
                            value: videoPlayerController!.value.position.inSeconds.toDouble(),
                            min: 0,
                            max: videoPlayerController!.value.duration.inSeconds.toDouble(),
                          ),
                        ),
                        renderTimeTextFromDuration(
                          videoPlayerController!.value.duration,
                        ),
                      ],
                    ),
                  )),
              if (showControls)
                Align(
                    // 오른쪽 위에 새 동영상 아이콘 위치
                    alignment: Alignment.topRight,
                    child: CustomIconButton(
                      onPressed: widget.onNewVideoPressed,
                      iconData: Icons.photo_camera_back,
                    )
                ),
              if (showControls)
                Align(
                    // 동영상 재생 관련 아이콘 중앙에 위치
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomIconButton(
                          // 되감기 버튼
                          onPressed: onReversePressed,
                          iconData: Icons.rotate_left,
                        ),
                        CustomIconButton(
                          // 재생/일시정지 버튼
                          onPressed: onPlayPressed,
                          iconData: videoPlayerController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        CustomIconButton(
                          // 앞으로 감기 버튼
                          onPressed: onForwardPressed,
                          iconData: Icons.rotate_right,
                        ),
                      ],
                    ),
                ),
            ],
          ),
        )
    );
  }

  Widget renderTimeTextFromDuration(Duration duration) {
    return Text(
      '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }

  void onReversePressed() {
    // 되감기 버튼을 눌렀을 때
    final currentPosition = videoPlayerController!.value.position;

    Duration position = const Duration();

    // 현재 실행 위치가 3초보다 길 때만 3초 빼기
    if (currentPosition.inSeconds > 3) {
      position = currentPosition - const Duration(seconds: 3);
    }

    videoPlayerController!.seekTo(position);
  }

  void onForwardPressed() {
    // 앞으로 감기 버튼 눌렀을 때
    final maxPosition = videoPlayerController!.value.duration;
    final currentPosition = videoPlayerController!.value.position;

    Duration position = const Duration();

    // 동영상의 길이에서 3초를 뺀 값보다 현재 위치가 짧을 때만 3초 더하기
    if ((maxPosition - const Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + const Duration(seconds: 3);
    }

    videoPlayerController!.seekTo(position);
  }

  void onPlayPressed() {
    if (videoPlayerController!.value.isPlaying) {
      videoPlayerController!.pause();
      return;
    }

    videoPlayerController!.play();
  }
}
