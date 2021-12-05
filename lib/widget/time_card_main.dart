import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mcmtimecards/config.dart';
import 'package:mcmtimecards/database/employee_api.dart';
import 'package:mcmtimecards/models/employee_model.dart';
import 'package:mcmtimecards/utility/dialog.dart';
import 'package:mcmtimecards/utility/get_address.dart';
import 'package:mcmtimecards/utility/my_style.dart';
import 'package:mcmtimecards/widget/time_card.dart';

class TimeCardMain extends StatefulWidget {
  const TimeCardMain({Key key}) : super(key: key);
  static GetMacAddress macaddress = GetMacAddress();
  // static List<Wifibssid> wifibssids = <Wifibssid>[];

  @override
  _TimeCardMainState createState() => _TimeCardMainState();
}

class _TimeCardMainState extends State<TimeCardMain> {
  final ImagePicker _picker = ImagePicker();
  File _selectedImageFile;
  String base64Image;
  String status = '';
  double screen = 400;
  var diftime = 0;
  // ignore: prefer_typing_uninitialized_variables
  var timestart;
  var outputFormat = DateFormat('dd/MM/yyyy hh:mm');
  String bssid;

  @override
  void initState() {
    super.initState();
    timestart = DateTime.now();
  }

  Future<String> reFreshBssid() async {
    String _bssid = await GetAddress.getBssid();
    return _bssid;
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('ลงเวลาทำงาน" ${TimeCardMain.macaddress.name}'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.33),
            radius: 1.0,
            colors: <Color>[Colors.white, Colors.blueGrey.shade800],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyStyle().titleH3('Date : ' + outputFormat.format(timestart)),
                // ignore: unnecessary_brace_in_string_interps
                // MyStyle().titleH3('Diference : ${diftime} '),
                buildTimeCard(),
                buildImage(),
                buildSaveData(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildTimeCard() {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      width: screen * 0.75,
      child: ElevatedButton(
        onPressed: () async {
          if (await GetAddress.checkWifiBase() == true) {
            timeCardActive();
          } else {
            normalDialog(context, 'ระบบลงเวลาทำงาน',
                'ท่านต้องต่อใช้งานกับ wifi ของบริษัทเท่านั้น');
          }
        },
        child: const Text("ลงเวลาทำงาน"),
        style: ElevatedButton.styleFrom(
          primary: MyStyle().darkColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  void timeCardActive() {
    TimeCard.employeeid = TimeCardMain.macaddress.employeeid;
    TimeCard.name = TimeCardMain.macaddress.name;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TimeCard(),
      ),
    );
  }

  Container buildImage() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Ink(
        color: Colors.grey[300],
        child: InkWell(
          onTap: () {
            getImage();
          },
          child: _selectedImageFile != null
              ? Image.file(
                  _selectedImageFile,
                  height: screen * 1,
                )
              : TimeCardMain.macaddress.urlimage != null &&
                      TimeCardMain.macaddress.urlimage != ""
                  ? Image.network(
                      AppConfig().url +
                          'images/${TimeCardMain.macaddress.employeeid}.jpg',
                      height: screen * 1,
                    )
                  : Container(
                      height: screen * .40,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.camera_alt_rounded),
                      ),
                    ),
        ),
      ),
    );
  }

  Container buildSaveData() {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      width: screen * 0.75,
      child: ElevatedButton(
        onPressed: () async {
          // ignore: unused_local_variable
          String result;
          EmployeeAPI emp = EmployeeAPI();
          if (null != _selectedImageFile) {
            TimeCardMain.macaddress.urlimage =
                "images/thumbnail/${TimeCardMain.macaddress.employeeid}.jpg";
            await startUpload();
            result = await emp.update_url_image({
              'employee_id': TimeCardMain.macaddress.employeeid,
              'url_image': TimeCardMain.macaddress.urlimage
            });
            normalDialog(context, 'อัพเดต รูปภาพ', result);
          }
        },
        child: const Text("Save"),
        style: ElevatedButton.styleFrom(
          primary: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  getImage() async {
    final selectFile = await _picker.getImage(source: ImageSource.camera);
    if (selectFile != null) {
      // ignore: avoid_print
      print(selectFile.path);
      setState(() {
        _selectedImageFile = File(selectFile.path);
        base64Image = base64Encode(_selectedImageFile.readAsBytesSync());
      });
    }
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  Future<void> startUpload() async {
    // setStatus('Uploading Image...');
    if (null == _selectedImageFile) {
      return;
    }
    await EmployeeAPI.upLoadImages(
        _selectedImageFile, TimeCardMain.macaddress.employeeid);
    await EmployeeAPI.upLoadthumbnail(
            _selectedImageFile, TimeCardMain.macaddress.employeeid)
        .then((value) {
      setStatus(value);
    });
  }
}
