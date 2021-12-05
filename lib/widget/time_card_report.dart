import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcmtimecards/database/timecard_api.dart';
import 'package:mcmtimecards/models/timecardreport_model.dart';

// ignore: must_be_immutable
class TimeCardReport extends StatefulWidget {
  String employeeid;
  int year;
  int month;
  bool approveot = false;
  TimeCardReport(this.employeeid, this.year, this.month, this.approveot,
      {Key key})
      : super(key: key);
  @override
  _TimeCardReportState createState() => _TimeCardReportState();
}

class _TimeCardReportState extends State<TimeCardReport> {
  var outputFormat = DateFormat('dd/MM/yyyy');
  Future<List<DataTimeCard>> timecards;

  @override
  void initState() {
    super.initState();
    timecards = TimeCardAPI()
        .getTimeCardData(widget.employeeid, widget.year, widget.month);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.approveot == true ? 'บันทึกอนุมัติโอที' : 'รายงานการลงเวลาเข้างาน'),
      ),
      body: FutureBuilder<List<DataTimeCard>>(
        future: timecards,
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var timecard = snapshot.data[index];
                  return Card(
                    elevation: 10.0,
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      onTap: () {
                        if (widget.approveot) {
                          // ignore: avoid_print
                          print('object');
                        }
                      },
                      leading: Text(
                        outputFormat.format(DateTime.parse(timecard.date)),
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      title: Text(
                          'เข้างาน : ${timecard.checkIn} ผลต่าง: ${timecard.startDif}',
                          style: TextStyle(
                              fontSize: 14,
                              color: timecard.startDif.contains('-')
                                  ? Colors.red
                                  : Colors.black)),
                      subtitle: Text(
                          timecard.checkOut == null
                              ? 'ออกงาน:'
                              : 'ออกงาน: ${timecard.checkOut} ผลต่าง: ${timecard.endDif}',
                          style: TextStyle(
                              color: timecard.endDif == null
                                  ? Colors.black
                                  : timecard.endDif.contains('-')
                                      ? Colors.red
                                      : Colors.black)),
                    ),
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
