import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:valve_controller/controller/home_controller.dart';
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buttonSwicthOnOff(),
              _buttonSwicthMode(),
              _buttonSwicthLog()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonSwicthOnOff() {
    return Obx(
      () => Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        child: TextButton(
          onPressed: () {
            homeScreenController
                .changeSwitchVale(homeScreenController.switchVale.value);
          },
          child: Padding(
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
    return Obx(
      () => TextButton(
        onPressed: () {
          homeScreenController.setSwitchModeAuto();
        },
        child: Column(
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
    return Obx(
      () => TextButton(
        onPressed: () {
          homeScreenController.setSwitchModeManual();
        },
        child: Column(
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
}
