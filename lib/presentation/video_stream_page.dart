import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:video_stream_app/core/utils/connection.dart';
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
    signaling.onAddRemoteStream = (stream) {
      remoteRenderer.srcObject = stream;
      setState(() {});
    };
  }

  @override
  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    roomIdController.dispose();
    super.dispose();
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
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RTCVideoView(
                  localRenderer,
                  mirror: true,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                )),
          ),
          Expanded(
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RTCVideoView(
                  remoteRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                )),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: roomIdController,
                  decoration: InputDecoration(
                    labelText: "Room ID",
                    hintText: "Enter Room ID",
                    hintStyle: TextStyle(color: Colors.black),
                    //border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white54,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    bool checkConnection =
                        await Connection.checkConnection(context);
                    if (checkConnection == false) {
                      return;
                    }
                    await signaling.joinRoom(
                        roomIdController.text, remoteRenderer);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Join Room')),
            ],
          ),
          SizedBox(
            height: 15,
          ), //
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  // height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () async {
                        bool checkConnection =
                            await Connection.checkConnection(context);
                        if (checkConnection == false) {
                          return;
                        }
                        await signaling.openUserMedia(
                            localRenderer, remoteRenderer);
                        setState(() {});
                      },
                      child: Text(
                        "Camera",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                    // height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () async {
                          bool checkConnection =
                              await Connection.checkConnection(context);
                          if (checkConnection == false) {
                            return;
                          }
                          roomIdController.text =
                              await signaling.createRoom(remoteRenderer);
                          setState(() {});
                        },
                        child: Text(
                          "Create Room",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ))),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () async {
                        await signaling.hangUp(localRenderer);
                        setState(() {
                          remoteRenderer.srcObject = null;
                          localRenderer.srcObject = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                        backgroundColor: Colors.red, // Red background
                        foregroundColor: Colors.white, // White icon
                        elevation: 5,
                      ),
                      child: Center(
                        child: const Icon(
                          Icons.call_end,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    )),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
