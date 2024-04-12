// // ignore_for_file: deprecated_member_use

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   const VideoPlayerScreen({required Key key}) : super(key: key);

//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;

//   @override
//   void initState() {
//     _controller = VideoPlayerController.network(
//       'Video_URL',
//     );

//     _initializeVideoPlayerFuture = _controller.initialize();

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             setState(() {
//               //pause
//               if (_controller.value.isPlaying) {
//                 _controller.pause();
//               } else {
//                 // play
//                 _controller.play();
//               }
//             });
//           },
//           child: Icon(
//             _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//           ),
//         ),
//         appBar: AppBar(),
//         body: FutureBuilder(
//           future: FirebaseFirestore.instance.collection('savePosts').get(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               return AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               );
//             } else {
//               return const Center(child: CircularProgressIndicator());
//             }
//           },
//         ));
//   }
// }
