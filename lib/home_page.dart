import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:valve_controller/controller/home_controller.dart';
import 'package:valve_controller/util/alert_util.dart';
import 'package:http/http.dart' as http;
import 'package:valve_controller/view_log_screen.dart';

DateTime scheduleTime = DateTime.now();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeScreenController = HomeScreenController();
  @override
  void initState() {
    super.initState();
    homeScreenController.getinit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff808B96),
        centerTitle: true,
        title: Text(widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            )),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (homeScreenController.isLoading.value) ...[
                  const SizedBox(height: 100),
                  const Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(
                        value: null,
                        strokeWidth: 5.0,
                      ),
                    ),
                  ),
                ] else ...[
                  homeScreenController.switchVale.value
                      ? _iconStatusON()
                      : _iconStatusOFF(),
                  const SizedBox(height: 20),
                  _buttonSwicthOnOff(),
                  _buttonSwicthMode(),
                  _buttonSwicthLog(),
                  getCheckStatus()
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconStatusON() {
    return SizedBox(height: 100, child: Image.asset('assets/accept.png'));
  }

  Widget _iconStatusOFF() {
    return SizedBox(height: 100, child: Image.asset('assets/cross.png'));
  }

  Widget _buttonSwicthOnOff() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      child: TextButton(
        onPressed: () async {
          if (homeScreenController.configuration.functionMode == 1) {
            await homeScreenController
                .changeSwitchVale(homeScreenController.switchVale.value);
          } else {
            return AlertUtil.showError(
                title: 'Notify',
                message: "You can't control the vale",
                showCloseButton: false);
          }
        },
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: homeScreenController.switchVale.value
                        ? Colors.orange
                        : Colors.grey,
                  ),
                  child: const Icon(
                    Icons.power_settings_new_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'Trun ${homeScreenController.switchVale.value ? 'on' : 'off'}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: homeScreenController.switchVale.value
                        ? Colors.orange
                        : Colors.grey,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonSwicthMode() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [autoButton(), manualButton()],
        ),
      ),
    );
  }

  Widget autoButton() {
    return TextButton(
      onPressed: () async {
        await homeScreenController.setAutoMode();
      },
      child: Obx(
        () => Column(
          children: [
            Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: homeScreenController.switchMode.first
                      ? Colors.green
                      : Colors.grey,
                ),
                child: const Text(
                  'A',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
            const SizedBox(height: 10),
            Text(
              'Auto',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: homeScreenController.switchMode.first
                    ? Colors.green
                    : Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget manualButton() {
    return TextButton(
      onPressed: () async {
        await homeScreenController.setManualMode();
      },
      child: Obx(
        () => Column(
          children: [
            Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: homeScreenController.switchMode.last
                      ? Colors.green
                      : Colors.grey,
                ),
                child: const Text(
                  'M',
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
            const SizedBox(height: 10),
            Text(
              'Manual',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: homeScreenController.switchMode.last
                    ? Colors.green
                    : Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buttonSwicthLog() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextButton(
        onPressed: () {
          Get.to(() => const ViewLogScreen(
                title: 'View Log',
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: const Icon(
                  Icons.view_list_rounded,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 20),
              const Text(
                'View Log',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getCheckStatus() {
    return TextButton(
        onPressed: () async {
          // var client = http.Client();
          // await client
          //     .get(Uri.http('sqlbytnn.000webhostapp.com', 'resetAlert'));
          homeScreenController.getCheckStatusNotify();
        },
        child: Text('-- Check status notify --'));
  }
}
