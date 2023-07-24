import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:valve_controller/controller/home_controller.dart';
import 'package:valve_controller/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:valve_controller/util/app_client.dart';

import 'util/endpoint.dart';

class AppService {
  static void initialize() {
    Get.put(HomeScreenController());
  }
}

void main() {
  Get.put(AppClient(http.Client()));

  Get.put(Endpoint());

  AppService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff808B96),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Module 1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        title: widget.title,
      ),
    );
  }
}
