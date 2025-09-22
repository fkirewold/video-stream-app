  
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
        Expanded(
          child: RTCVideoView(localRenderer,mirror:true),
        ),
        Expanded(
          child: RTCVideoView(remoteRenderer),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: ()async{
              await signaling.openUserMedia(localRenderer, remoteRenderer);
              setState(() {
              });
            }, child: Text("Open Camera & Mic")),
            ElevatedButton(onPressed: ()async{
              await signaling.createRoom(remoteRenderer);
              setState(() {
              });
            }, child: Text("Create Room")),
            // ElevatedButton(onPressed: ()async{
            //   await signaling.hangUp(localRenderer);
            //   setState(() {
            //     remoteRenderer.srcObject=null;
            //     localRenderer.srcObject=null;
            //   });
            // }, child: Text("Hang Up")),
          ],
        )
      ],
    );
  }
}