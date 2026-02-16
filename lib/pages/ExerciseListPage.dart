import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ExerciseListPage extends StatefulWidget {
  final String category;
  const ExerciseListPage({super.key, required this.category});

  @override
  State<ExerciseListPage> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  List videos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future fetchVideos() async {
    final response = await http.get(
      Uri.parse("http://192.168.1.4:3000/exercise/${widget.category}"),
    );

    final data = json.decode(response.body);

    setState(() {
      videos = data["videos"];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.category} Exercises")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const Icon(Icons.play_circle),
                    title: Text(video["title"]),
                    onTap: () {
                      Get.toNamed('/exercise-video',
                          arguments: video["url"]);
                    },
                  ),
                );
              },
            ),
    );
  }
}
