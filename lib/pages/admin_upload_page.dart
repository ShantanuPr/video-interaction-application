import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminUploadPage extends StatefulWidget {
  const AdminUploadPage({super.key});

  @override
  State<AdminUploadPage> createState() => _AdminUploadPageState();
}

class _AdminUploadPageState extends State<AdminUploadPage> {
  List<File> videoFiles = [];
  String category = "leg";
  bool isUploading = false;

  /// Pick multiple videos
  Future pickVideos() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        videoFiles.addAll(
          result.paths.map((path) => File(path!)).toList(),
        );
      });
    }
  }

  /// Remove selected video
  void removeVideo(int index) {
    setState(() {
      videoFiles.removeAt(index);
    });
  }

  /// Upload videos to backend
  Future uploadVideos() async {
    if (videoFiles.isEmpty) return;

    setState(() => isUploading = true);

    try {
      for (var file in videoFiles) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse("http://192.168.1.4:3000/upload-exercise"),
        );

        request.fields['category'] = category;

        request.files.add(
          await http.MultipartFile.fromPath('video', file.path),
        );

        var response = await request.send();

        if (response.statusCode != 200) {
          throw Exception("Upload failed");
        }
      }

      setState(() {
        videoFiles.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All videos uploaded successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload failed")),
      );
    }

    setState(() => isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Exercise Upload"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Upload Exercise Videos",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            /// Category dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                value: category,
                isExpanded: true,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: "leg", child: Text("Leg Exercise")),
                  DropdownMenuItem(value: "knee", child: Text("Knee Exercise")),
                  DropdownMenuItem(value: "shoulder", child: Text("Shoulder")),
                  DropdownMenuItem(value: "back", child: Text("Back Exercise")),
                ],
                onChanged: (value) {
                  setState(() => category = value!);
                },
              ),
            ),

            const SizedBox(height: 20),

            /// Pick videos button
            ElevatedButton.icon(
              onPressed: pickVideos,
              icon: const Icon(Icons.video_call),
              label: const Text("Select Videos"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),

            const SizedBox(height: 20),

            /// Selected videos preview
            if (videoFiles.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: videoFiles.length,
                  itemBuilder: (context, index) {
                    final file = videoFiles[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.video_file),
                        title: Text(file.path.split('/').last),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeVideo(index),
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 10),

            /// Upload button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isUploading ? null : uploadVideos,
                child: isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Upload to Server"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
