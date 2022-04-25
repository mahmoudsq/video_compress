import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';

class ProgressDialogWidget extends StatefulWidget {
  const ProgressDialogWidget({Key? key}) : super(key: key);

  @override
  _ProgressDialogWidgetState createState() => _ProgressDialogWidgetState();
}

class _ProgressDialogWidgetState extends State<ProgressDialogWidget> {
  late Subscription subscription;
  double? progress;

  @override
  void initState() {
    super.initState();
    subscription = VideoCompress.compressProgress$.subscribe((event) {
      setState(() {
        progress = event;
      });
    });
  }

  @override
  void dispose() {
    VideoCompress.cancelCompression();
    subscription.unsubscribe();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final value = (progress == null) ? progress : progress!/100;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:  [
          const Text('Compress Video ....',style: TextStyle(fontSize: 20),),
          const SizedBox(height: 25,),
          LinearProgressIndicator(value: value,minHeight: 12,),
          const SizedBox(height: 20,),
          ElevatedButton(onPressed: ()=> VideoCompress.cancelCompression(),
          child: const Text('Cancel'),)
        ],
      ),
    );
  }
}
