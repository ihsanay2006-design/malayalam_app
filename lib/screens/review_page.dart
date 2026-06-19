import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {

  List<String> videos = [];

  @override
  void initState() {
    super.initState();
    loadVideos();
  }

  Future loadVideos() async {
    final result = await FirebaseStorage.instance.ref("student_videos").listAll();

    for (var item in result.items) {
      String url = await item.getDownloadURL();
      videos.add(url);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Student Submissions")),

      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, i) {

          final controller = VideoPlayerController.network(videos[i]);

          return FutureBuilder(
            future: controller.initialize(),
            builder: (context, snap) {

              if (!snap.hasData) return const CircularProgressIndicator();

              return AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              );
            },
          );
        },
      ),
    );
  }
}