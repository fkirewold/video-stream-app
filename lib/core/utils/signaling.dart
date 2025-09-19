import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
class Signaling {
 
    RTCPeerConnection? peerConnection;
    MediaStream? localStream;
    MediaStream? remoteStream;

    Function(MediaStream stream)? onAddRemoteStream;


    Future<String> createRoom(RTCVideoRenderer remoteRenderer)async{
     FirebaseFirestore firestore=FirebaseFirestore.instance;
     DocumentReference roomRef=await firestore.collection("rooms").doc();
    
      Map<String,dynamic> configuration={
        "iceServers":[
          {
            "urls":["stun:stun.l.google.com:19302"]
          }
        ]
      };
      peerConnection=await createPeerConnection(configuration);
      registerPeerConnectionListners();
      localStream?.getTracks().forEach((track){
        peerConnection?.addTrack(track,localStream!);


      });
    }
   void registerPeerConnectionListners(){
    peerConnection?.onIceGatheringState=(RTCIceGatheringState state){
      print('ICE Gathering state changed:$state');
    };

    peerConnection?.onConnectionState=(RTCPeerConnectionState state){
      print('Conection state change:$state');

    }
    peerConnection?.onSignalingState=(RTCSignalingState state ){
      print('Signaling State changed:$state');
    };
    peerConnection?.onAddStream=(MediaStream stream){
      onAddRemoteStream?.call(stream);
      remoteStream=stream;
    };

    }

}