// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:mcmtimecards/database/employee_api.dart';
import 'package:mcmtimecards/utility/dialog.dart';
import 'package:mcmtimecards/utility/my_style.dart';

class ChangePassword extends StatefulWidget {
  String username;
  ChangePassword(this.username, {Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  double screen = 400;
  bool statusRedEye1 = true, statusRedEye2 = true;
  String password1 = '', password2 = '', msgreslt = '';

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.33),
            radius: 1.0,
            colors: <Color>[Colors.white, Colors.green[200]],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildLogo(),
                MyStyle().titleH1('เปลี่ยนรหัสผ่าน'),
                buildPassword1(),
                buildPassword2(),
                builLogin(),
                MyStyle().titleSucceed(msgreslt),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildLogo() {
    // ignore: sized_box_for_whitespace
    return Container(width: screen * 0.4, child: MyStyle().showLogo());
  }

  Container buildPassword1() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white60,
      ),
      margin: const EdgeInsets.only(top: 16),
      width: screen * 0.75,
      child: TextField(
        onChanged: (value) => password1 = value.trim(),
        obscureText: statusRedEye1,
        style: TextStyle(color: MyStyle().darkColor),
        decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: statusRedEye1
                    ? const Icon(Icons.remove_red_eye)
                    : const Icon(Icons.remove_red_eye_outlined),
                onPressed: () {
                  setState(() {
                    statusRedEye1 = !statusRedEye1;
                  });
                }),
            hintStyle: TextStyle(color: MyStyle().darkColor),
            hintText: 'Password:',
            prefixIcon: Icon(
              Icons.lock_outline,
              color: MyStyle().darkColor,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: MyStyle().darkColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: MyStyle().lightColor),
            )),
      ),
    );
  }

  Container buildPassword2() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white60,
      ),
      margin: const EdgeInsets.only(top: 16),
      width: screen * 0.75,
      child: TextField(
        onChanged: (value) => password2 = value.trim(),
        obscureText: statusRedEye2,
        style: TextStyle(color: MyStyle().darkColor),
        decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: statusRedEye2
                    ? const Icon(Icons.remove_red_eye)
                    : const Icon(Icons.remove_red_eye_outlined),
                onPressed: () {
                  setState(() {
                    statusRedEye2 = !statusRedEye2;
                  });
                }),
            hintStyle: TextStyle(color: MyStyle().darkColor),
            hintText: 'Confirm Password:',
            prefixIcon: Icon(
              Icons.lock_outline,
              color: MyStyle().darkColor,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: MyStyle().darkColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: MyStyle().lightColor),
            )),
      ),
    );
  }

  Container builLogin() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: screen * 0.75,
      child: ElevatedButton(
        onPressed: () {
          if ((password1?.isEmpty ?? true) || (password2?.isEmpty ?? true)) {
            normalDialog(context, 'Check fill data',
                'Have Space ? Please Fill Every Blank');
          } else {
            if (password1.trim() == password2.trim()) {
              changePassword();
            } else {
              normalDialog(
                  context, 'Check fill data', 'รหัสผ่านที่ท่านกรอก ไม่ตรงกัน');
            }
          }
        },
        child: const Text("Save"),
        style: ElevatedButton.styleFrom(
          primary: MyStyle().darkColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Future<void> changePassword() async {
    try {
      String mesg =
          await EmployeeAPI.changePassword(widget.username, password1.trim());
      var _mesg = mesg.split(",");
      setState(() {
        msgreslt = _mesg[0];
      });
    } catch (e) {
      setState(() {
        msgreslt = e.message;
      });
    }
  }
}
