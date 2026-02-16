import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BodyPartPage extends StatelessWidget {
  const BodyPartPage({super.key});

  final List bodyParts = const [
    {"name": "Leg", "icon": Icons.directions_run, "category": "leg"},
    {"name": "Knee", "icon": Icons.accessibility_new, "category": "knee"},
    {"name": "Back", "icon": Icons.airline_seat_flat, "category": "back"},
    {"name": "Shoulder", "icon": Icons.fitness_center, "category": "shoulder"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Body Part")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: bodyParts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final part = bodyParts[index];

            return GestureDetector(
              onTap: () {
                Get.toNamed('/exercise-list', arguments: part["category"]);
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(part["icon"], size: 50),
                    const SizedBox(height: 10),
                    Text(
                      part["name"],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
