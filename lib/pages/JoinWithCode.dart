import 'package:agora_video_call/video_call.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinWithCode extends StatefulWidget {
  const JoinWithCode({Key? key}) : super(key: key);

  @override
  State<JoinWithCode> createState() => _JoinWithCodeState();
}

class _JoinWithCodeState extends State<JoinWithCode> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Back button
            Positioned(
              top: 10,
              left: 10,
              child: InkWell(
                onTap: Get.back,
                child: const Icon(Icons.arrow_back, size: 30),
              ),
            ),

            // Title
            const Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "Enter meeting code below",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // TextField
            Positioned(
              top: 110,
              left: 20,
              right: 20,
              child: TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  hintText: "Meeting code",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            // Join button
            Positioned(
              top: 180,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: (){
                   Get.to(() => const VideoCall(channelName: 'test',));
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 50),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Join",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
