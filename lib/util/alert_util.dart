import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertUtil {
  static Future<void> showError({
    String title = '',
    String message = '',
    bool showCloseButton = true,
  }) async {
    return Get.defaultDialog(
      title: title,
      titlePadding: const EdgeInsets.only(
        top: 20,
        bottom: 10,
      ),
      contentPadding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
      ),
      content: SingleChildScrollView(
        child: Text(
          message,
          textAlign: TextAlign.center,
          maxLines: 10,
        ),
      ),
      cancel: (showCloseButton == true)
          ? TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                'CLOSE'.tr,
                style: const TextStyle(
                    // fontFamily: ThemeConfig.primaryFont,
                    // color: ThemeConfig.primaryColor,
                    ),
              ),
            )
          : null,
    );
  }
}
