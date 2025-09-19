import 'package:flutter_webrtc/flutter_webrtc.dart';
class Signaling {
 
    RTCPeerConnection? peerConnection;
    MediaStream? localStream;
    MediaStream? remoteStream;

    Function(MediaStream stream)? onAddRemoteStream;

}