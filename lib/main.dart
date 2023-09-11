import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:valve_controller/controller/home_controller.dart';
import 'package:valve_controller/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:valve_controller/model/configuration.dart';
import 'package:valve_controller/util/app_client.dart';
import 'package:workmanager/workmanager.dart';

import 'util/endpoint.dart';

int id = 0;
FlutterLocalNotificationsPlugin flip = new FlutterLocalNotificationsPlugin();

// app_icon needs to be a added as a drawable
// resource to the Android head project.
var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
var IOS = new IOSInitializationSettings();

// initialise settings for both Android and iOS device.
var settings = new InitializationSettings(android: android, iOS: IOS);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AppClient(http.Client()));
  Get.put(Endpoint());
  AppService.initialize();

  Workmanager().initialize(
      // The top level function, aka callbackDispatcher
      callbackDispatcher,

      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      isInDebugMode: true);
  // Periodic task registration
  Workmanager().registerPeriodicTask(
    "2",

    //This is the value that will be
    // returned in the callbackDispatcher
    "simplePeriodicTask", initialDelay: Duration(seconds: 0),

    // When no frequency is provided
    // the default 15 minutes is set.
    // Minimum frequency is 15 min.
    // Android will automatically change
    // your frequency to 15 min
    // if you have configured a lower frequency.
    frequency: Duration(minutes: 2),
  );

  runApp(const MyApp());
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print('task: $task');
    print('inputData: $inputData');
    await _isAndroidPermissionGranted();

    return Future.value(true);
  });
}

Future<void> _isAndroidPermissionGranted() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flip.initialize(
    initializationSettings,
  );
  var client = http.Client();
  try {
    var response = await client.get(Uri.http(
        'sqlbytnn.000webhostapp.com', 'communication/configuration.json'));

    var json = jsonDecode(response.body);
    final Configuration configuration = Configuration.fromJson(json);
    if (configuration.valveStatus == 1 &&
        configuration.functionMode == 0 &&
        configuration.alertStatus == 1) {
      await client.get(Uri.http('sqlbytnn.000webhostapp.com', 'resetAlert'));
      await _showNotificationWithDefaultSound(flip);
    }
  } finally {
    client.close();
  }
}

Future<void> _showNotificationWithDefaultSound(flip) async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  await flip.show(0, 'Alert', 'The system detects abnormal water flow',
      platformChannelSpecifics,
      payload: 'Default_Sound');
}

class AppService {
  static void initialize() {
    Get.put(HomeScreenController());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  void initState() {
    super.initState();
    checkPermissionNotification();
  }

  void checkPermissionNotification() async {
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      print('isGranted');
      print('initialize');
    } else {
      await Permission.notification.request();
    }
  }

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
