# 📹 Flutter WebRTC Video Streaming App

## Overview
A real-time video streaming app built with Flutter, using WebRTC for peer-to-peer communication, WebSocket for signaling, and STUN servers for NAT traversal. Ideal for live video chat, remote collaboration, or virtual classrooms.

## 🛠️ Features
- Real-time video and audio streaming
- Peer-to-peer connection via WebRTC
- WebSocket-based signaling
- STUN server integration for NAT traversal
- Cross-platform support (Android & iOS)

##  Tech Stack

| Technology        | Purpose                                 |
|-------------------|------------------------------------------|
| `flutter_webrtc`  | WebRTC implementation in Flutter         |
| `WebSocket`       | Signaling between peers                  |
| `STUN server`     | Discover public IP and port for NAT      |
| `Dart`            | Programming language                     |
| `Flutter`         | UI framework                             |

## Getting Started

### Prerequisites
- Flutter SDK installed
- Android Studio or Xcode
- STUN server (e.g. `stun:stun.l.google.com:19302`)
- WebSocket signaling server (custom or Firebase)

### Installation
```bash
git clone https://github.com/your-username/flutter-webrtc-video-app.git
cd flutter-webrtc-video-app
flutter pub get
