import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mcmtimecards/config.dart';
import 'package:mcmtimecards/database/employee_api.dart';
import 'package:mcmtimecards/utility/dialog.dart';
import 'package:mcmtimecards/utility/get_address.dart';
import 'package:mcmtimecards/utility/my_style.dart';

class Register extends StatefulWidget {
  static String employeeid, name, urlImage, macaddress;

  const Register({Key key}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final ImagePicker _picker = ImagePicker();
  File _selectedImageFile;
  String base64Image;
  String status = '';
  double screen = 400;
  String macaddress = Register.macaddress;
  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('ลงทะเบียน ${Register.name}'),
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
                MyStyle().titleH3('Mac Address : $macaddress'),
                buildGetMacAddress(),
                buildImage(),
                buildSaveData()
              ],
            ),
          ),
        ),
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
              : Register.urlImage != null && Register.urlImage != ""
                  ? Image.network(
                      AppConfig().url + 'images/${Register.employeeid}.jpg',
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

  Container buildGetMacAddress() {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      width: screen * 0.75,
      child: ElevatedButton(
        onPressed: () async {
          // macaddress = await GetAddress.getMacAddress();
          macaddress = await GetAddress.getMacAddress();
          if (macaddress != null) {
            setState(() {
              macaddress;
            });
          }
        },
        child: const Text("Get Mac Address"),
        style: ElevatedButton.styleFrom(
          primary: MyStyle().darkColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
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
          if (macaddress.isEmpty || macaddress == null) {
            normalDialog(
                context, 'ตรวจสอบการบันทึก', 'ท่านต้อง Get Mac Address ก่อน');
          } else {
            // ignore: unused_local_variable
            String result;
            EmployeeAPI emp = EmployeeAPI();
            if (null != _selectedImageFile) {
              Register.urlImage = "images/thumbnail/${Register.employeeid}.jpg";
              await startUpload();
              result = await emp.update_url_image({
                'employee_id': Register.employeeid,
                'url_image': Register.urlImage
              });
            }
            bool macresult = await emp.update_macaddress({
              'employee_id': Register.employeeid,
              'mac_address': macaddress
            });
            if (macresult == true) {
              Navigator.of(context).pop();
            } else {
              normalDialog(context, 'การบันทึกข้อมูล',
                  "เครื่องนี้มีการลงทะเบียนแล้ว กรุณาตรวจสอบด้วย");
            }
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
    await EmployeeAPI.upLoadImages(_selectedImageFile, Register.employeeid);
    await EmployeeAPI.upLoadthumbnail(_selectedImageFile, Register.employeeid)
        .then((value) {
      setStatus(value);
    });
  }
}
