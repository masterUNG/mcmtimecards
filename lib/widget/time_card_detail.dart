import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mcmtimecards/database/timecard_api.dart';
import 'package:mcmtimecards/models/timecard_model.dart';
import 'package:mcmtimecards/utility/dialog.dart';
import 'package:mcmtimecards/utility/get_address.dart';
import 'package:mcmtimecards/utility/my_company.dart';

class TimeCardDetail extends StatefulWidget {
  final String employeeid;
  final String name;

  const TimeCardDetail(this.employeeid, this.name, {Key key}) : super(key: key);

  @override
  _TimeCardDetailState createState() => _TimeCardDetailState();
}

class _TimeCardDetailState extends State<TimeCardDetail> {
  var outputFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
  TimeCardAPI timeCardAPI = TimeCardAPI();
  TimeCardModel timeCard;
  Future<TimeCardModel> _getData;
  String _startResult = "";
  String _endResult = "";

  @override
  void initState() {
    super.initState();
    _getData = getTimecard();
    initializeDateFormatting();
    outputFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
  }

  @override
  void dispose() {
    super.dispose();
  }

  final String _title = 'บันทึกเวลาทำงาน';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        // actions: <Widget>[
        //   IconButton(
        //       icon: const Icon(Icons.close),
        //       onPressed: () {
        //         confirmDialog(context);
        //       })
        // ],
      ),
      body: FutureBuilder(
        future: _getData,
        builder: (BuildContext context, AsyncSnapshot<TimeCardModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var result = snapshot.data;
            if (result.starttime != null) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 80,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xff77007c)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              MyCompany().companyName,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: double.infinity,
                        height: 80,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xff229954)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              widget.name,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 75,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xff2471A3)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'เวลาเข้างาน',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Expanded(
                              child: Text(
                                outputFormat.format(result?.starttime),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: result?.id == 0
                                        ? Colors.white
                                        : Colors.yellowAccent),
                                textAlign: TextAlign.right,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (await GetAddress.checkWifiBase() == true) {
                              if (result?.id == 0) {
                                timeCard = result;
                                showAlertDialog(
                                    context,
                                    'ยืนยันบันทึกข้อมูลเข้าทำงาน',
                                    'start_time');
                              } else {
                                setState(() {
                                  _startResult = _startResult == ""
                                      ? "ท่านได้ทำการบันทึกเวลาเข้างานแล้ว...."
                                      : "";
                                  _getData = getTimecard();
                                });
                              }
                            } else {
                              normalDialog(context, 'ระบบลงเวลาทำงาน',
                                  'ท่านต้องต่อใช้งานกับ wifi ของบริษัทเท่านั้น');
                            }
                          },
                          child: const Text(
                            'บันทึกเข้างาน',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Text(_startResult,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0)),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 75,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xff2471A3)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'เวลาออกงาน',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Expanded(
                              child: Text(
                                outputFormat.format(result?.endtime),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: result?.note == "start_time" ||
                                            result?.note == "end_time"
                                        ? Colors.white
                                        : Colors.yellowAccent),
                                textAlign: TextAlign.right,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (await GetAddress.checkWifiBase() == true) {
                              if (result?.note == 'end_time') {
                                timeCard = result;
                                showAlertDialog(context,
                                    'ยืนยันบันทึกข้อมูลออกงาน', result?.note);
                              } else if (result?.note == 'start_time') {
                                setState(() {
                                  _endResult = _endResult == ""
                                      ? "ท่านยังไม่ได้ทำการบันทึกเวลาเข้างาน...."
                                      : "";
                                });
                              } else {
                                setState(() {
                                  _endResult = _endResult == ""
                                      ? "ท่านได้ทำการบันทึกเวลาออกงานแล้ว...."
                                      : "";
                                  // _getData = getTimecard();
                                });
                              }
                            } else {
                              normalDialog(context, 'ระบบลงเวลาทำงาน',
                                  'ท่านต้องต่อใช้งานกับ wifi ของบริษัทเท่านั้น');
                            }
                          },
                          child: const Text(
                            'บันทึกออกงาน',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(_endResult,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0)),
                    ],
                  ),
                ),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<TimeCardModel> getTimecard() async {
    var result = await timeCardAPI.getTimeCardToday(widget.employeeid);
    return result;
  }

  showAlertDialog(BuildContext context, String _confirmmsg, String _state) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget deleteButton = TextButton(
      child: const Text(
        "Ok",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        if (_state == 'start_time') {
          setState(() {
            _startResult = "กำลังบันทึกข้อมูล";
            timeCardAPI.saveTimeIn(timeCard).whenComplete(() {
              setState(() {
                _getData = getTimecard();
              });
            });
          });
          setState(() {
            _startResult = "";
          });
        } else {
          setState(() {
            _endResult = "กำลังบันทึกข้อมูล";
            timeCardAPI.saveTimeOut(timeCard).whenComplete(() {
              setState(() {
                _getData = getTimecard();
              });
            });
          });
          setState(() {
            _endResult = "";
          });
        }
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(_confirmmsg),
      content: const Text('ท่านต้องการบันทึกข้อมูลใช่หรือไม่'),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  confirmDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget closeButton = TextButton(
      child: const Text(
        "Close",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        exit(0);
        // ignore: dead_code
        SystemNavigator.pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm app closure"),
      content: const Text("Do you want to close this App?"),
      actions: [
        cancelButton,
        closeButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
