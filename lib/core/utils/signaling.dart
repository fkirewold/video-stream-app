import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Signaling {
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;

    Map<String, dynamic> configuration = {
      "iceServers": [
        {
          "urls": ["stun:stun.l.google.com:19302"]
        }
      ]
    };
  Function(MediaStream stream)? onAddRemoteStream;

  Future<String> createRoom(RTCVideoRenderer remoteRenderer) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference roomRef = firestore.collection("rooms").doc();

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
  Future<void> openUserMedia(RTCVideoRenderer localRenderer, RTCVideoRenderer remoteRenderer) async {
 
 final Map<String,dynamic> mediaConstraints={
  'audio':true,
  'video': {
    'facingMode':'user',
  }
 };
 localStream= await navigator.mediaDevices.getUserMedia(mediaConstraints);
 localRenderer.srcObject=localStream;
 remoteRenderer.srcObject=await createLocalMediaStream('key');

}
  Future<void> hangUp() async {
    try {
      await localStream?.dispose();
      await remoteStream?.dispose();
      await peerConnection?.close();
      peerConnection = null;
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> joinRoom(String roomId, RTCVideoRenderer remoteRenderer) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference roomRef = firestore.collection("rooms").doc(roomId);
    DocumentSnapshot roomSnapshot = await roomRef.get();
    if (roomSnapshot.exists) {
      print('Room found');
      Map<String, dynamic> data = roomSnapshot.data() as Map<String, dynamic>;
      var offer = data['offer'];
      print('Got offer: $offer');
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

      var calleeCandidatesCollection= roomRef.collection('calleeCandidates');
      peerConnection?.onIceCandidate =(RTCIceCandidate candidate)
      {
          calleeCandidatesCollection.add(candidate.toMap());
        
      };

      RTCSessionDescription offerDescription = RTCSessionDescription(
          offer['sdp'], offer['type']);
      await peerConnection!.setRemoteDescription(offerDescription);
      RTCSessionDescription answer = await peerConnection!.createAnswer();
      print('Answer created: ${answer.sdp}');
      await peerConnection!.setLocalDescription(answer);
      Map<String,dynamic> roomWithAnswer={
        'answer':answer.toMap()
      };
      await roomRef.update(roomWithAnswer);

      // Listening for remote ICE candidates
      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((change) {
          if (change.type == DocumentChangeType.added) {
            Map<String, dynamic> data =
                change.doc.data() as Map<String, dynamic>;
            print('Got new remote ICE candidate: $data');
            RTCIceCandidate candidate = RTCIceCandidate(
                data['candidate'], data['sdpMid'], data['sdpMLineIndex']);
            peerConnection?.addCandidate(candidate);
          }
        });
      });
    }
  }

}
