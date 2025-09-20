  
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:video_stream_app/core/utils/signaling.dart';

class VideoStreamPage extends StatefulWidget {
  const VideoStreamPage({super.key});

  @override
  State<VideoStreamPage> createState() => _VideoStreamPageState();
}

class _VideoStreamPageState extends State<VideoStreamPage> {
  FirebaseFirestore instance=FirebaseFirestore.instance;
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer=RTCVideoRenderer();
  Signaling signaling=Signaling();
  @override void initState() {
    super.initState();
    initRenderers();
  }
  @override void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    super.dispose();
    signaling.onAddRemoteStream=(stream){
      remoteRenderer.srcObject=stream;
      setState(() {
      });
    };
  }

initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50,),
        Row(
          children: [
            Expanded(child: RTCVideoView(localRenderer)),
            Expanded(child: RTCVideoView(remoteRenderer)),
          ],
        ),
      ],
    );
  }
}