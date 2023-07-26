import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:valve_controller/main.dart';
import 'package:valve_controller/model/configuration.dart';
import 'package:valve_controller/util/alert_util.dart';
import 'package:valve_controller/util/app_client.dart';
import 'package:valve_controller/util/endpoint.dart';

class HomeScreenController extends GetxController {
  var configuration = Configuration();
  final endpoint = Get.find<Endpoint>();
  final client = Get.find<AppClient>();
  var switchVale = false.obs;
  var switchMode = [false, false].obs;
  var isLoading = false.obs;

  setSwitchVale(bool value) {
    switchVale.value = value;
  }

  setSwitchModeAuto() async {
    switchMode.first = true;
    switchMode.last = false;
  }

  setSwitchModeManual() async {
    switchMode.first = false;
    switchMode.last = true;
  }

  Future<void> getinit() async {
    try {
      debugPrint('getinit');
      isLoading.value = true;
      await getConfiguration();
      isLoading.value = false;
      debugPrint('${configuration.toJson()}');
    } catch (e) {
      return AlertUtil.showError(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  Future<void> getConfiguration() async {
    try {
      debugPrint('getConfiguration');
      var json = await client.get(endpoint.getConfiguration());
      configuration = Configuration.fromJson(json);

      if (configuration.valveStatus == 0) {
        setSwitchVale(true);
      } else {
        setSwitchVale(false);
      }
      if (configuration.functionMode == 0) {
        setSwitchModeAuto();
      } else {
        setSwitchModeManual();
      }

      debugPrint('${configuration.toJson()}');
    } catch (e) {
      return AlertUtil.showError(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  Future<void> changeSwitchVale(bool value) async {
    try {
      debugPrint('changeSwitchVale');
      await client.get(endpoint.getValveMode());
      await getConfiguration();
    } catch (e) {
      return AlertUtil.showError(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  Future<void> setManualMode() async {
    try {
      debugPrint('getManualMode');
      await client.get(endpoint.getManualMode());
      await getConfiguration();
    } catch (e) {
      return AlertUtil.showError(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  Future<void> setAutoMode() async {
    try {
      debugPrint('setAutoMode');
      await client.get(endpoint.getAutoMode());
      await getConfiguration();
    } catch (e) {
      return AlertUtil.showError(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  Future<void> resetAlert() async {
    try {
      debugPrint('resetAlert');
      await client.get(endpoint.resetAlert());
      await getConfiguration();
    } catch (e) {
      return AlertUtil.showError(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  Future<void> getCheckStatusNotify() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flip.initialize(
      initializationSettings,
    );
    try {
      await getConfiguration();

      if (configuration.valveStatus == 0 &&
          configuration.functionMode == 0 &&
          configuration.alertStatus == 1) {
        _showNotificationWithDefaultSound(flip);
      }
    } finally {}
  }

  Future _showNotificationWithDefaultSound(flip) async {
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
    await resetAlert();
  }
}
