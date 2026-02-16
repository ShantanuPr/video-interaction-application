import 'package:agora_video_call/pages/ExerciseCategoriesPage.dart';
import 'package:agora_video_call/pages/ExerciseListPage.dart';
import 'package:agora_video_call/pages/HomePages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/exercise_video_page.dart';
import 'pages/admin_upload_page.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const Homepage()),
        GetPage(name: '/exercise', page: () => const BodyPartPage()),
        GetPage(name: '/exercise-list', page: () => ExerciseListPage(category: Get.arguments)),
        GetPage(name: '/exercise-video', page: () => ExerciseVideoPage(videoUrl: Get.arguments)),
        GetPage(name: '/admin', page: () => const AdminUploadPage()),
      ],
    ),
  );
}
