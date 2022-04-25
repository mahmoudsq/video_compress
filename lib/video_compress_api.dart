
import 'dart:io';

import 'package:video_compress/video_compress.dart';

class VideoCompressApi{
  static Future<MediaInfo?> compressVideo(File file) async{
    await VideoCompress.setLogLevel(0);
    try{
      return await VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.LowQuality,
        includeAudio: false,
      );
    }catch(e){
      VideoCompress.cancelCompression();
    }
    return null;
  }
}