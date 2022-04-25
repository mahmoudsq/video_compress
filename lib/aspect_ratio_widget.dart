import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:video_test/progress_dialog_widget.dart';

import 'video_compress_api.dart';

class AspectRatioVideo extends StatefulWidget {
  const AspectRatioVideo(this.controller, {Key? key}) : super(key: key);

  final VideoPlayerController? controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController? get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller!.value.isInitialized) {
      initialized = controller!.value.isInitialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller!.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller!.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  MediaInfo? compressedVideo;
  Future compressVideo() async{
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context)=> const Dialog(child: ProgressDialogWidget(),)
    );
    final info = await VideoCompressApi.compressVideo(File(controller!.dataSource));
    setState(() {
      compressedVideo = info;
    });
    Navigator.of(context).pop();
  }

  Widget bulidVideoCompressedInfo(){
    if(compressedVideo == null) return Container();
    final size = compressedVideo!.filesize! / 1000;
    VideoPlayerController compressedController = VideoPlayerController.file(
        File(compressedVideo!.path.toString()));
    return Column(
      children: [
    /*    AspectRatio(
            aspectRatio: compressedController.value.aspectRatio,
            child: VideoPlayer(compressedController)
        ),*/
        const Text(
          'Compressed Video Info',
          style: TextStyle(fontSize: 24,),
        ),
        const SizedBox(height: 15,),
        Text(
          'Size $size kb',
          style: const TextStyle(fontSize: 24,),
        ),
        const SizedBox(height: 5,),
        Text(
          compressedVideo!.path.toString(),
          style: const TextStyle(fontSize: 22,),
        ),
      ],
    );
  }
  Widget videoInfo(String? path){
    if(path == null) return Container();
    File videoFile = File(path);
    final size = videoFile.lengthSync() / 1000;
    return Column(
      children: [
        const Text(
          'Original Video Info',
          style: TextStyle(fontSize: 24,),
        ),
        const SizedBox(height: 15,),
        Text(
          'Size $size kb',
          style: const TextStyle(fontSize: 24,),
        ),
        const SizedBox(height: 5,),
        Text(
          path,
          style: const TextStyle(fontSize: 22,),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: controller!.value.aspectRatio / 0.5,
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  VideoPlayer(controller!),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        controller!.value.isPlaying
                            ? controller!.pause()
                            : controller!.play();
                      });
                    },
                    child: Icon(
                      controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                  ),
                ],
              ),
            ),

            videoInfo(controller!.dataSource.substring(7)),
            MaterialButton(
              child: const Text('Compress Video'),
              onPressed: compressVideo,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 15,),
            bulidVideoCompressedInfo()
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}