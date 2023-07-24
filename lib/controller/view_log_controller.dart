import 'package:get/get.dart';
import 'package:valve_controller/util/app_client.dart';
import 'package:valve_controller/util/endpoint.dart';

import '../model/view_log_model.dart';

class ViewLogController extends GetxController {
  final endpoint = Get.find<Endpoint>();
  final client = Get.find<AppClient>();
  var viewLogs = <ViewLogModel>[].obs;
  var isLoading = false.obs;

  Future<void> getHistory() async {
    try {
      viewLogs.clear();
      isLoading.value = true;

      var json =
          await client.get(endpoint.getHistory(), useUserCredential: false);

      var data = List.generate(json['data'].length,
          (index) => ViewLogModel.fromJson(json['data'][index]));
      viewLogs.addAll(data);
      print(viewLogs.length);
      isLoading.value = false;
    } catch (error) {
      isLoading.value = false;
      rethrow;
    }
  }
}
