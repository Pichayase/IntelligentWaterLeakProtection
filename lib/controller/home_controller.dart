import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  var switchVale = false.obs;
  var switchMode = [false, false].obs;

  changeSwitchVale(bool value) {
    if (value) {
      setSwitchVale(false);
    } else {
      setSwitchVale(true);
    }
  }

  setSwitchVale(bool value) {
    switchVale.value = value;
  }

  setSwitchModeAuto() {
    switchMode.first = true;
    switchMode.last = false;
  }

  setSwitchModeManual() {
    switchMode.first = false;
    switchMode.last = true;
  }
}
