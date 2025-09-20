
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
class Signaling {
 
    RTCPeerConnection? peerConnection;
    MediaStream? localStream;
    MediaStream? remoteStream;

    Function(MediaStream stream)? onAddRemoteStream;


    Future<String> createRoom(RTCVideoRenderer remoteRenderer)async{
     FirebaseFirestore firestore=FirebaseFirestore.instance;
     DocumentReference roomRef= firestore.collection("rooms").doc();
      

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
      var callerCandidateCollection=roomRef.collection("callerCandidates");
      peerConnection?.onIceCandidate=(RTCIceCandidate candidate)async{
              print('Got candidate: ${candidate.toMap()}');
          callerCandidateCollection.add(candidate.toMap());

      };
      RTCSessionDescription offer=await peerConnection!.createOffer();
      await peerConnection?.setLocalDescription(offer);
      print('offer created:$offer');

      Map<String,dynamic> roomWithOffer={
        "offer":{
          "type":offer.type,
          "sdp":offer.sdp
        }
      };
      await roomRef.set(roomWithOffer);
      roomRef.snapshots().listen((snapshot) async{
        Map<String,dynamic> data=snapshot.data() as Map<String,dynamic>;
        if(peerConnection?.getRemoteDescription()!=null && data['answer']!=null){
          print('Answer received:$data');
          RTCSessionDescription answer=RTCSessionDescription(data['answer']['sdp'],data['answer']['type']);
          await peerConnection?.setRemoteDescription(answer);
        }
      });




      return roomRef.id;
    }
   void registerPeerConnectionListners(){
    peerConnection?.onIceGatheringState=(RTCIceGatheringState state){
      print('ICE Gathering state changed:$state');
    };

    peerConnection?.onConnectionState=(RTCPeerConnectionState state){
      print('Conection state change:$state');

    };
    peerConnection?.onSignalingState=(RTCSignalingState state ){
      print('Signaling State changed:$state');
    };
    peerConnection?.onAddStream=(MediaStream stream){
      onAddRemoteStream?.call(stream);
      remoteStream=stream;
    };

    }

}