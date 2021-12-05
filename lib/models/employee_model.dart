// To parse this JSON data, do
//
//     final employeeModel = employeeModelFromJson(jsonString);

import 'dart:convert';

EmployeeModel employeeModelFromJson(String str) =>
    EmployeeModel.fromJson(json.decode(str));

String employeeModelToJson(EmployeeModel data) => json.encode(data.toJson());

class EmployeeModel {
  EmployeeModel({
    this.data,
  });

  List<Employee> data;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        data: json["data"] == null
            ? null
            : List<Employee>.from(
                json["data"].map((x) => Employee.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Employee {
  Employee({
    this.employeeId,
    this.firstName,
    this.lastName,
    // this.username,
    // this.password,
    // this.userstatus,
    this.urlImage,
    this.macAddress,
  });

  String employeeId;
  String firstName;
  String lastName;
  // String username;
  // String password;
  // String userstatus;
  dynamic urlImage;
  String macAddress;

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        employeeId: json["employee_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        // username: json["username"] == null ? null : json["username"],
        // password: json["password"] == null ? null : json["password"],
        // userstatus: json["user_status"] == null ? null : json["user_status"],
        urlImage: (json["url_image"] == null ||
                json["url_image"] == json["employee_id"])
            ? null
            : json["url_image"],
        macAddress: (json["mac_address"] == null ||
                json["mac_address"] == json["employee_id"])
            ? null
            : json["mac_address"],
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "first_name": firstName,
        "last_name": lastName,
        // "username": username == null ? null : username,
        // "password": password == null ? null : password,
        // "user_status": userstatus == null ? null : userstatus,
        "url_image": urlImage,
        "mac_address": macAddress,
      };

  // ignore: non_constant_identifier_names
  static Map<String, dynamic> to_Json(Employee emp) {
    return {
      'employee_id': emp.employeeId,
      'first_name': emp.firstName,
      'last_name': emp.lastName,
      // 'username': emp.username,
      // 'password': emp.password,
      // 'user_status': emp.userstatus,
      'url_image': emp.urlImage,
      'mac_address': emp.macAddress,
    };
  }
}

class CheckAuthen {
  String employeeid;
  String name;
  String message;
  CheckAuthen({this.employeeid, this.name, this.message});
}

class GetMacAddress {
  String employeeid;
  String name;
  String urlimage;
  // String wifibssid1;
  // String wifibssid2;
  String message;
  GetMacAddress(
      {this.employeeid,
      this.name,
      this.urlimage,
      // this.wifibssid1,
      // this.wifibssid2,
      this.message});
}
