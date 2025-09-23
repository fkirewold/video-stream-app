
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:video_stream_app/firebase_options.dart';
import 'package:video_stream_app/presentation/video_stream_page.dart';

void main() async
{
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform
   );

  runApp(VideoStream());
}

class VideoStream extends StatelessWidget {
  const  VideoStream({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Video Stream"),
          centerTitle: true,
        ),
        body: VideoStreamPage()
      ),
    );
  }
}