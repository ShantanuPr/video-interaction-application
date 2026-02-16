import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewMeeting extends StatefulWidget {
  const NewMeeting({Key? key}) : super(key: key);

  @override
  State<NewMeeting> createState() => _NewMeetingState();
}

class _NewMeetingState extends State<NewMeeting> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _joinMeeting() {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a meeting code",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    print("Joining meeting with code: $code");
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
                onTap: () => Navigator.pop(context),
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
                  "Enter your code below",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // TextField
            Positioned(
              top: 110,
              left: 15,
              right: 15,
              child: TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  hintText: "Meeting code",
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.link),
                ),
              ),
            ),

            // Invite Link button
            Positioned(
              top: 180,
              left: 20,
              right: 20,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Generate invite link
                },
                icon: const Icon(Icons.add),
                label: const Text(
                  "Invite Link",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),

            // Divider
            const Positioned(
              top: 245,
              left: 20,
              right: 20,
              child: Divider(),
            ),

            // Start Call button
            Positioned(
              top: 265,
              left: 20,
              right: 20,
              child: OutlinedButton.icon(
                onPressed: _joinMeeting,
                icon: const Icon(Icons.video_call),
                label: const Text(
                  "Start Call",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(
                    color: Colors.blueAccent,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
