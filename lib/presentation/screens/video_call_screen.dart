// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
//
// class VideoCallScreen extends StatefulWidget {
//   final String currentUserId;
//   final String receiverId;
//   final String receiverName;
//   final bool isCaller;
//
//   const VideoCallScreen({
//     Key? key,
//     required this.currentUserId,
//     required this.receiverId,
//     required this.receiverName,
//     required this.isCaller,
//   }) : super(key: key);
//
//   @override
//   _VideoCallScreenState createState() => _VideoCallScreenState();
// }
//
// class _VideoCallScreenState extends State<VideoCallScreen> {
//   late final RTCVideoRenderer _localRenderer;
//   late final RTCVideoRenderer _remoteRenderer;
//   RTCPeerConnection? _peerConnection;
//   MediaStream? _localStream;
//
//   @override
//   void initState() {
//     super.initState();
//     _initRenderers();
//     _initWebRTC();
//   }
//
//   Future<void> _initRenderers() async {
//     _localRenderer = RTCVideoRenderer();
//     _remoteRenderer = RTCVideoRenderer();
//     await _localRenderer.initialize();
//     await _remoteRenderer.initialize();
//   }
//
//   Future<void> _initWebRTC() async {
//     try {
//       _localStream = await navigator.mediaDevices.getUserMedia({
//         'audio': true,
//         'video': {'facingMode': 'user'}
//       });
//       _localRenderer.srcObject = _localStream;
//
//       _peerConnection = await createPeerConnection({
//         'iceServers': [{'urls': 'stun:stun.l.google.com:19302'}]
//       });
//
//       _localStream!.getTracks().forEach((track) {
//         _peerConnection!.addTrack(track, _localStream!);
//       });
//
//       _peerConnection!.onIceCandidate = (candidate) {
//         // Handle ICE candidates
//       };
//
//       _peerConnection!.onTrack = (event) {
//         if (event.streams.isNotEmpty) {
//           _remoteRenderer.srcObject = event.streams[0];
//         }
//       };
//
//       if (widget.isCaller) {
//         final offer = await _peerConnection!.createOffer();
//         await _peerConnection!.setLocalDescription(offer);
//         // Send offer via signaling
//       }
//     } catch (e) {
//       print('WebRTC Error: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(  // Changed from Column to Stack for proper layout
//         children: [
//           // Full-screen remote video
//           Positioned.fill(
//             child: RTCVideoView(_remoteRenderer),
//           ),
//           Positioned(
//             right: 20,
//             bottom: 20,
//             width: 120,
//             height: 180, child: Container(
//                 decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2),),
//                 child: RTCVideoView(_localRenderer),
//           ),
//           ),
//      ],
//     ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _localRenderer.dispose();
//     _remoteRenderer.dispose();
//     _peerConnection?.close();
//     _localStream?.dispose();
//     super.dispose();
//   }
// }