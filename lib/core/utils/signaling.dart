import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Signaling {
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;

  Function(MediaStream stream)? onAddRemoteStream;

  Future<String> createRoom(RTCVideoRenderer remoteRenderer) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference roomRef = firestore.collection("rooms").doc();

    Map<String, dynamic> configuration = {
      "iceServers": [
        {
          "urls": ["stun:stun.l.google.com:19302"]
        }
      ]
    };
    peerConnection = await createPeerConnection(configuration);
    registerPeerConnectionListners();
    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });
    peerConnection?.onTrack=(RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        onAddRemoteStream?.call(event.streams[0]);
        remoteStream = event.streams[0];
      }
    };

    var callerCandidatesCollection= roomRef.collection('callerCandidates');
    peerConnection?.onIceCandidate =(RTCIceCandidate candidate)
    {
        callerCandidatesCollection.add(candidate.toMap());
      
    };

    RTCSessionDescription offer= await peerConnection!.createOffer();
    print('Local Offer created : ${offer.sdp}'
    );
    await peerConnection!.setLocalDescription(offer);
    Map<String,dynamic> roomWithOffer={
      'offer':offer.toMap()
    };
    await roomRef.set(roomWithOffer);
    
    print('New room created with SDK offer. Room ID: ${roomRef.id}');
   // var currentRoomText = 'Current room is ${roomRef.id} - You are the caller!';
    return roomRef.id;
  }

  void registerPeerConnectionListners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE Gathering state changed:$state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('Conection state change:$state');
    };
    peerConnection?.onSignalingState = (RTCSignalingState state) {
      print('Signaling State changed:$state');
    };
  
  }
}
