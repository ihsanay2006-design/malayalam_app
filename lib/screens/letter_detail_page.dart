import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ NEW
import 'dart:typed_data';

class LetterDetailPage extends StatefulWidget {
  final String letter;
  final List items;

  const LetterDetailPage({
    super.key,
    required this.letter,
    required this.items,
  });

  @override
  State<LetterDetailPage> createState() => _LetterDetailPageState();
}

class _LetterDetailPageState extends State<LetterDetailPage> {
  VideoPlayerController? controller;

  /// 🎥 Upload student video
  Future uploadStudentVideo(Uint8List bytes) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("student_videos/${DateTime.now().millisecondsSinceEpoch}.mp4");

    await ref.putData(bytes);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Video uploaded ✅")),
    );
  }

  /// 🎥 Open YouTube URL
  Future openYoutube(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid video URL")),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// 🔙 BACK BUTTON (FIXED)
      appBar: AppBar(
        title: Text("Letter: ${widget.letter}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: widget.items.length,
        itemBuilder: (context, i) {
          final d = widget.items[i];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,

            child: Padding(
              padding: const EdgeInsets.all(12),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🖼 IMAGE (FIXED ERROR)
                  if (d['image'] != null &&
                      d['image'] != "" &&
                      !d['image'].toString().contains("your_image.jpg"))
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        d['image'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.contain,

                        /// 🚫 HIDE ERROR
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(); // no red error
                        },
                      ),
                    ),

                  const SizedBox(height: 10),

                  /// 🔤 TEXTS
                  Text(
                    d['malayalam'] ?? "",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    d['english'] ?? "",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),

                  /// ✅ TAMIL TEXT ADDED
                  if (d['tamil'] != null)
                    Text(
                      d['tamil'],
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.blueGrey,
                      ),
                    ),

                  const SizedBox(height: 10),

                  /// 🔊 AUDIO (DUMMY UI ONLY)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Audio feature coming soon 🎧")),
                          );
                        },
                      ),

                      /// 🎥 LOCAL VIDEO (IF EXISTS)
                      IconButton(
                        icon: const Icon(Icons.play_circle),
                        onPressed: () {
                          if (d['video'] != null &&
                              !d['video'].toString().contains("youtube")) {
                            controller?.dispose();

                            controller =
                                VideoPlayerController.networkUrl(Uri.parse(d['video']))
                                  ..initialize().then((_) {
                                    if (!mounted) return;
                                    setState(() {});
                                    controller!.play();
                                  });
                          }
                        },
                      ),
                    ],
                  ),

                  /// 🎥 VIDEO PLAYER
                  if (controller != null &&
                      controller!.value.isInitialized)
                    AspectRatio(
                      aspectRatio: controller!.value.aspectRatio,
                      child: VideoPlayer(controller!),
                    ),

                  const SizedBox(height: 10),

                  /// 🎥 YOUTUBE LINK (NEW FEATURE)
                  if (d['video'] != null &&
                      d['video'].toString().contains("youtube"))
                    GestureDetector(
                      onTap: () => openYoutube(d['video']),
                      child: const Text(
                        "▶ Watch Video",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                  const SizedBox(height: 10),

                  /// 📤 STUDENT VIDEO UPLOAD
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.upload),
                      label: const Text("Upload My Practice Video"),
                      onPressed: () async {
                        final res = await FilePicker.platform
                            .pickFiles(type: FileType.video);

                        if (res != null &&
                            res.files.first.bytes != null) {
                          await uploadStudentVideo(
                              res.files.first.bytes!);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}