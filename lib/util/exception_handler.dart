import 'dart:io';
import 'package:get/get.dart';
import 'package:valve_controller/util/platform_exception.dart';
import 'alert_util.dart';

class ExceptionHandler {
  static Future<void> handleException(Object error) {
    if (error is SocketException) {
      return AlertUtil.showError(
        title: 'network error'.tr,
        message: 'Please check your internet connection and pull to refresh'.tr,
      );
    } else if (error is HttpException) {
      return AlertUtil.showError(
        title: 'error'.tr,
        message: error.toString(),
      );
    } else if (error is ValidateException) {
      return AlertUtil.showError(
        title: error.title.tr,
        message: error.message.tr,
      );
    } else {
      return AlertUtil.showError(
        title: 'error',
        message: error.toString(),
      );
    }
  }
}
