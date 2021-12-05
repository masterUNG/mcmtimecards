// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mcmtimecards/config.dart';
import 'dart:convert';
import 'package:mcmtimecards/models/employee_model.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:mcmtimecards/utility/my_data.dart';

class EmployeeAPI {
  static Future<Employee> getEmployee(String employeeid) async {
    Employee employee = Employee();
    var _url = 'api/hr/employee/get_employee.php';
    var _body = jsonEncode({"employee_id": employeeid});
    var _response = await http.post(Uri.parse(AppConfig().url + _url),
        headers: AppConfig().header, body: _body);
    if (_response.statusCode == 200) {
      var _result = json.decode(_response.body);
      if (_result['result'] == 'true') {
        employee.employeeId = _result['employee_id'];
        employee.firstName = _result['first_name'];
        employee.lastName = _result['last_name'];
        // employee.username = _result['username'];
        // employee.userStatus = _result['user_status'];
        employee.urlImage = _result['url_image'];
        employee.macAddress = _result['mac_address'];
        // employee.branch_id = _result['branch_id'];
      }
    }
    return employee;
  }

  Future<bool> update_macaddress(Object user) async {
    var _url = 'api/hr/employee/update_macaddress.php';
    var _body = jsonEncode(user);
    // String _result = "";
    bool _result = false;
    await http
        .post(Uri.parse(AppConfig().url + _url),
            headers: AppConfig().header, body: _body)
        .then((result) {
      if (result.statusCode == 200) {
        // var result = json.decode(result.body);
        // _result = _dataresult['message'];
        _result = true;
        // } else {
        //   _result = "บันทึกไม่สำเร็จ";
      }
    }).catchError((error) {
      // _result = error.message;
      // ignore: avoid_print
      print(error);
    });
    return _result;
  }

  Future<String> update_url_image(Object urlimage) async {
    var _url = 'api/hr/employee/update_url_image.php';
    var _body = jsonEncode(urlimage);
    String _result = "";
    await http
        .post(Uri.parse(AppConfig().url + _url),
            headers: AppConfig().header, body: _body)
        .then((result) {
      if (result.statusCode == 200) {
        var _dataresult = json.decode(result.body);
        _result = _dataresult['message'];
      } else {
        _result = "บันทึกไม่สำเร็จ";
      }
    }).catchError((error) {
      _result = error.message;
    });
    return _result;
  }

  Future<List<Employee>> loadAllEmployee() async {
    // var emp = {"company_id": "0135564016067", "branch_id": "00000"};
    var emp = MyData().company;
    var _url = 'api/hr/employee/read.php';
    // var _body = jsonEncode(MyCompany().company);
    var _body = jsonEncode(emp);
    var _response = await http.post(Uri.parse(AppConfig().url + _url),
        headers: AppConfig().header, body: _body);
    return employeeModelFromJson(_response.body).data;
  }

  static Future<CheckAuthen> checkPassword(
      String username, String password) async {
    CheckAuthen emp = CheckAuthen();
    try {
      final msg = jsonEncode({"username": username, "password": password});
      var _url = 'api/hr/security/passwordcheck.php';
      var _response = await http.post(Uri.parse(AppConfig().url + _url),
          headers: AppConfig().header, body: msg);
      var _result = json.decode(_response.body);
      if (_response.statusCode == 200) {
        if (_result['result'] == 'true') {
          emp.employeeid = _result['employee_id'];
          emp.name = _result['first_name'] + ' ' + _result['last_name'];
          emp.message = _result['message'];
        } else {
          emp.message = _result['message'];
        }
      }
    } catch (e) {
      emp.message = e.message;
      // ignore: avoid_print
      print(e.message);
    }
    return emp;
  }

  static Future<String> changePassword(String username, String password) async {
    String mesg;
    try {
      final msg = jsonEncode({"username": username, "password": password});
      var _url = 'api/hr/security/createpass.php';
      var _response = await http.post(Uri.parse(AppConfig().url + _url),
          headers: AppConfig().header, body: msg);
      var _result = json.decode(_response.body);
      if (_result['result'] == 'true') {
        mesg = _result['message'] + ',true';
      } else {
        mesg = _result['message'] + 'false';
      }
    } catch (e) {
      mesg = e.message + 'false';
    }
    return mesg;
  }

  static Future<String> upLoadImages(File tmpFile, String _fileName) async {
    String errMessage = 'Error Uploading Image';
    String _result = "";
    String _url = 'api/hr/employee/uploadimage.php';
    String _uploadEndPoint = AppConfig().url + _url;
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(tmpFile.path);
    File compressedFile = await FlutterNativeImage.compressImage(tmpFile.path,
        quality: 80,
        targetWidth: 600,
        targetHeight: (properties.height * 600 / properties.width).round());

    String fileName = compressedFile.path.split('/').last;
    String base64Image = base64Encode(compressedFile.readAsBytesSync());
    await http.post(Uri.parse(_uploadEndPoint), body: {
      "image": base64Image,
      "name": fileName,
      "filename": _fileName
    }).then((result) {
      _result = result.statusCode == 200 ? result.body : errMessage;
    }).catchError((error) {
      _result = error;
    });
    return _result;
  }

  static Future<String> upLoadthumbnail(File tmpFile, String _fileName) async {
    String errMessage = 'Error Uploading Image';
    String _result = "";
    String _url = 'api/hr/employee/uploadthumbnail.php';
    String _uploadEndPoint = AppConfig().url + _url;
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(tmpFile.path);
    File compressedFile = await FlutterNativeImage.compressImage(tmpFile.path,
        quality: 80,
        targetWidth: 200,
        targetHeight: (properties.height * 200 / properties.width).round());

    String fileName = compressedFile.path.split('/').last;
    String base64Image = base64Encode(compressedFile.readAsBytesSync());
    await http.post(Uri.parse(_uploadEndPoint), body: {
      "image": base64Image,
      "name": fileName,
      "filename": _fileName
    }).then((result) {
      _result = result.statusCode == 200 ? result.body : errMessage;
    }).catchError((error) {
      _result = error;
    });
    return _result;
  }

  static Future<GetMacAddress> getMacaddress(String macaddress) async {
    GetMacAddress mac = GetMacAddress();
    try {
      final msg = jsonEncode({"mac_address": macaddress});
      var _url = 'api/hr/employee/get_mac.php';
      var _response = await http.post(Uri.parse(AppConfig().url + _url),
          headers: AppConfig().header, body: msg);
      var _result = json.decode(_response.body);
      if (_response.statusCode == 200) {
        if (_result['result'] == 'true') {
          mac.employeeid = _result['employee_id'];
          mac.name = _result['first_name'] + ' ' + _result['last_name'];
          mac.urlimage = _result['url_image'];
          // mac.wifibssid1 = _result['wifi_bssid1'];
          // mac.wifibssid1 = _result['wifi_bssid2'];
          mac.message = _result['message'];
        } else {
          mac.message = _result['message'];
        }
      }
    } catch (e) {
      mac.message = e.message;
      // ignore: avoid_print
      print(e.message);
    }
    return mac;
  }
}
