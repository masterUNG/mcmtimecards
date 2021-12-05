import 'package:flutter/material.dart';
import 'package:mcmtimecards/database/employee_api.dart';
import 'package:mcmtimecards/models/employee_model.dart';
import 'package:mcmtimecards/utility/dialog.dart';
import 'package:mcmtimecards/utility/my_style.dart';
import 'package:mcmtimecards/widget/main_menu.dart';

class Authen extends StatefulWidget {
  const Authen({Key key}) : super(key: key);

  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  double screen = 400;
  bool statusRedEye = true;
  String username = '', password = '', msgreslt = '';
  int logincount = 0;
  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      // floatingActionButton: buildRegister(),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.33),
            radius: 1.0,
            colors: <Color>[Colors.white, MyStyle().primaryColor],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildLogo(),
                MyStyle().titleH1('ระบบลงเวลาทำงาน'),
                buildUser(),
                buildPassword(),
                builLogin(),
                MyStyle().titleError(msgreslt),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TextButton buildRegister() {
  //   return TextButton(
  //     onPressed: () => Navigator.pushNamed(context, '/register'),
  //     child: Text(
  //       'New Register',
  //       style: TextStyle(color: Colors.white),
  //     ),
  //   );
  // }

  Container builLogin() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: screen * 0.75,
      child: ElevatedButton(
        onPressed: () {
          if ((username?.isEmpty ?? true) || (password?.isEmpty ?? true)) {
            normalDialog(context, 'Check fill data',
                'Have Space ? Please Fill Every Blank');
          } else {
            checkAuthen();
          }
        },
        child: const Text("Login"),
        style: ElevatedButton.styleFrom(
          primary: MyStyle().darkColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Container buildUser() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white70),
      margin: const EdgeInsets.only(top: 16),
      width: screen * 0.75,
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) => username = value.trim(),
        style: TextStyle(color: MyStyle().darkColor),
        decoration: InputDecoration(
            hintStyle: TextStyle(color: MyStyle().darkColor),
            hintText: 'Username:',
            prefixIcon: Icon(
              Icons.perm_identity,
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

  Container buildPassword() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white60,
      ),
      margin: const EdgeInsets.only(top: 16),
      width: screen * 0.75,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        obscureText: statusRedEye,
        style: TextStyle(color: MyStyle().darkColor),
        decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: statusRedEye
                    ? const Icon(Icons.remove_red_eye)
                    : const Icon(Icons.remove_red_eye_outlined),
                onPressed: () {
                  setState(() {
                    statusRedEye = !statusRedEye;
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

  Container buildLogo() {
    // ignore: sized_box_for_whitespace
    return Container(width: screen * 0.4, child: MyStyle().showLogo());
  }

  Future<void> checkAuthen() async {
    try {
      CheckAuthen chk = CheckAuthen();
      chk = await EmployeeAPI.checkPassword(username, password);
      if (chk.employeeid == null) {
        setState(() {
          logincount++;
          msgreslt = chk.message + ' Login Count $logincount';
        });
      } else {
        MainMenu.employee_id = chk.employeeid;
        MainMenu.username = username;
        MainMenu.name = chk.name;
        Navigator.pushNamedAndRemoveUntil(
            context, '/mainmenu', (route) => false);
      }
    } catch (e) {
      setState(() {
        msgreslt = e.message;
      });
    }
  }
}
