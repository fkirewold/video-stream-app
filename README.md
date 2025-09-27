# Flutter WebRTC Video Streaming App

## Overview
A real-time video streaming app built with Flutter, using WebRTC for peer-to-peer communication, WebSocket for signaling, and STUN servers for NAT traversal. Ideal for live video chat, remote collaboration, or virtual classrooms.

## Features
- Real-time video and audio streaming
- Peer-to-peer connection via WebRTC
- push notification using FCM
- WebSocket-based signaling
- STUN server integration for NAT traversal
- Cross-platform support (Android & iOS)

## Tech Stack

| Technology        | Purpose                                 |
|-------------------|------------------------------------------|
| `flutter_webrtc`  | WebRTC implementation in Flutter         |
| `firebase firestore| To store Candidates or Network Path     |
| `WebSocket`       | Signaling between peers                  |
| `STUN server`     | Discover public IP and port for NAT      |
| `Dart`            | Programming language                     |
| `Flutter`         | UI framework                             |
| `Connectivity plus`| Checking Internet Connnection           |
## Getting Started

### Prerequisites
- Flutter SDK installed
- Android Studio or Xcode or vscode
- STUN server (e.g. `stun:stun.l.google.com:19302`)
- WebSocket signaling server (Firebase Firestore)

## ▶ How to Run
### 1. Clone the Repository
```bash
git clone https://github.com/fkirewold/video-stream-app.git
cd video-stream-app
```
### 2. Install Dependencies
```bash
flutter pub get
```
### 3. Configure STUN & Signaling Server
**Update your ICE server and signaling logic in your Dart files:**
```dart
final Map<String, dynamic> config = {
  'iceServers': [
    {'urls': 'stun:stun.l.google.com:19302'},
  ],
};
```
### 4. Run the App
```bash
flutter run
```
**You can test on:**
- Two physical devices
- Emulators (with proper camera/mic permissions)
- Same or different networks (STUN server helps with NAT traversal)
### 📄 License
This project is licensed under the MIT License. You are free to use, modify, and distribute this software with proper attribution.
