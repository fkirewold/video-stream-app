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
  FirebaseFirestore instance = FirebaseFirestore.instance;
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  final TextEditingController roomIdController = TextEditingController();
  Signaling signaling = Signaling();
  @override
  void initState() {
    super.initState();
    initRenderers();
  }

  @override
  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    roomIdController.dispose();
    super.dispose();
    signaling.onAddRemoteStream = (stream) {
      remoteRenderer.srcObject = stream;
      setState(() {});
    };
  }

  initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: RTCVideoView(localRenderer, mirror: true),
          ),
          Expanded(
            child: RTCVideoView(remoteRenderer),
          ),
           Spacer(),
        TextField(
          style: TextStyle(color: Colors.blue),
          controller: roomIdController,
          decoration: InputDecoration(
            labelText: "Room ID",
            hintText: "Enter Room ID",

            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            
           
          ),
        ),
        SizedBox(height: 15,),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue
                    ),
                  
                      onPressed: () async {
                        await signaling.openUserMedia(
                            localRenderer, remoteRenderer);
                        setState(() {});
                      },
                      child: Text("Camera",style: TextStyle(color: Colors.white,fontSize: 15),)),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue
                      ),
                      onPressed: () async {
                       roomIdController.text=await signaling.createRoom(remoteRenderer);
                        setState(() {});
                      },
                      child: Text("Create Room",style: TextStyle(color: Colors.white,fontSize: 15),))),
                ),
              
               SizedBox(width: 10),
             
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,),
                      onPressed: () async {
                        await signaling.hangUp(localRenderer);
                        setState(() {
                          remoteRenderer.srcObject = null;
                          localRenderer.srcObject = null;
                        });
                      },
                      child: Text("Hang Up",style: TextStyle(color: Colors.white,fontSize: 15),)),
                ),
              ),
            ],
          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }
}
