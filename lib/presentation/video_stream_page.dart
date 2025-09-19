  
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoStreamPage extends StatefulWidget {
  const VideoStreamPage({super.key});

  @override
  State<VideoStreamPage> createState() => _VideoStreamPageState();
}

class _VideoStreamPageState extends State<VideoStreamPage> {
  FirebaseFirestore instance=FirebaseFirestore.instance;
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer=RTCVideoRenderer();
  @override void initState() {
    super.initState();
    initRenderers();
  }
  @override void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    super.dispose();
  }

initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child:ElevatedButton(onPressed: ()async{
          await instance.collection("users").add({
        "name":"John Doe",  });
          }, child: Text('Add  User to FireStore',style:TextStyle(color: Colors.green),))
        ),
        RTCVideoView(localRenderer)
      ],
    );
  }
}