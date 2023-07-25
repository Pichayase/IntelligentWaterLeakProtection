import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:valve_controller/controller/view_log_controller.dart';
import 'package:valve_controller/util/exception_handler.dart';

DateTime scheduleTime = DateTime.now();

class ViewLogScreen extends StatefulWidget {
  const ViewLogScreen({super.key, required this.title});

  final String title;

  @override
  State<ViewLogScreen> createState() => _ViewLogScreenState();
}

class _ViewLogScreenState extends State<ViewLogScreen> {
  final viewLogController = ViewLogController();

  @override
  void initState() {
    super.initState();
    onInit();
  }

  onInit() async {
    await viewLogController
        .getHistory()
        .catchError((error) => ExceptionHandler.handleException(error));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff808B96),
            centerTitle: true,
            title: Text(widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                )),
          ),
          body: viewLogController.isLoading.value
              ? const Center(child: Text('Loading...'))
              : viewLogController.viewLogs.isEmpty
                  ? const Center(child: Text('Not found'))
                  : Padding(
                      padding: const EdgeInsets.all(0),
                      child: DataTable2(
                          headingRowColor: MaterialStateColor.resolveWith(
                            (states) =>
                                const Color(0xff808B96).withOpacity(0.2),
                          ),
                          columnSpacing: 12,
                          horizontalMargin: 12,
                          minWidth: 100,
                          columns: const [
                            DataColumn2(
                              label: Text('Date'),
                              size: ColumnSize.L,
                            ),
                            DataColumn2(
                              label: Text('Time'),
                              size: ColumnSize.L,
                            ),
                            DataColumn2(
                              label: Text('Flow rate'),
                              size: ColumnSize.L,
                            ),
                          ],
                          rows: List<DataRow>.generate(
                              viewLogController.viewLogs.length,
                              (index) => DataRow(cells: [
                                    DataCell(
                                      Text(
                                          '${viewLogController.viewLogs[index].date}'),
                                    ),
                                    DataCell(
                                      Text(
                                          '${viewLogController.viewLogs[index].time}'),
                                    ),
                                    DataCell(
                                      Text(
                                          '${viewLogController.viewLogs[index].val}'),
                                    ),
                                  ]))),
                    )),
    );
  }
}
