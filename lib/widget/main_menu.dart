import 'package:flutter/material.dart';
import 'package:mcmtimecards/utility/my_style.dart';
import 'package:mcmtimecards/widget/change_pass.dart';
import 'package:mcmtimecards/widget/emp_list.dart';

class MainMenu extends StatefulWidget {
  // ignore: non_constant_identifier_names
  static String employee_id, username, name;

  const MainMenu({Key key}) : super(key: key);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  Widget currentWidget = EmployeeList("register", "ลงทะเบียนพนักงาน");
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().primaryColor,
      ),
      drawer: buildDrawer(),
      body: currentWidget,
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
                elevation: 10.0,
                margin: const EdgeInsets.all(5),
                child: buildMainMenuDrawerHeader()),
            Card(
                elevation: 10.0,
                margin: const EdgeInsets.all(5),
                child: buildMenuItemRegister()),
            Card(
                elevation: 10.0,
                margin: const EdgeInsets.all(5),
                child: buildMenuItemApproOt()),
            Card(
                elevation: 10.0,
                margin: const EdgeInsets.all(5),
                child: buildMenuItemReports()),
            Card(
                elevation: 10.0,
                margin: const EdgeInsets.all(5),
                child: buildMenuItemTimeCards()),
            Card(
                elevation: 10.0,
                margin: const EdgeInsets.all(5),
                child: buildMenuItemChangePassword()),
            buildSignOut(),
          ],
        ),
      ),
    );
  }

  ListTile buildMenuItemRegister() {
    return ListTile(
      leading: const Icon(
        Icons.face,
        size: 36,
      ),
      title: const Text('ลงทะเบียน'),
      subtitle: const Text('ลงทะเบียน พนักงาน'),
      onTap: () {
        setState(() {
          currentWidget = EmployeeList("register", "ลงทะเบียนพนักงาน");
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile buildMenuItemApproOt() {
    return ListTile(
      leading: const Icon(
        Icons.more_time,
        size: 36,
      ),
      title: const Text('อนุมัติ ทำโอที'),
      subtitle: const Text('อนุมัติ ให้พนักงานทำโอที'),
      onTap: () {
        setState(() {
          currentWidget = EmployeeList("approv_ot", "อนุมัติ ทำโอที");
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile buildMenuItemReports() {
    return ListTile(
      leading: const Icon(
        Icons.report,
        size: 36,
      ),
      title: const Text('รายงาน'),
      subtitle: const Text('รายงานการลงเวลาการทำงาน'),
      onTap: () {
        setState(() {
          currentWidget = EmployeeList("report", "รายงาน");
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile buildMenuItemTimeCards() {
    return ListTile(
      leading: const Icon(
        Icons.access_time,
        size: 36,
      ),
      title: const Text('ลงเวลาแทนพนักงาน'),
      subtitle: const Text('ลงเวลาเข้าออกแทนพนักงาน'),
      onTap: () {
        setState(() {
          currentWidget = EmployeeList("timecard", "ลงเวลาแทนพนักงาน");
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile buildMenuItemChangePassword() {
    return ListTile(
      leading: const Icon(
        Icons.report,
        size: 36,
      ),
      title: const Text('เปลี่ยนรหัสผ่าน'),
      subtitle: Text('ของ ${MainMenu.name}'),
      onTap: () {
        setState(() {
          currentWidget = ChangePassword(MainMenu.username);
        });
        Navigator.pop(context);
      },
    );
  }

  UserAccountsDrawerHeader buildMainMenuDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/header.jpg'), fit: BoxFit.cover),
      ),
      accountName: MyStyle().titleH2(MainMenu.name),
      accountEmail: MyStyle().titleH3(MainMenu.username),
      // currentAccountPicture: Image.asset('images/logo.png'),
    );
  }

  Column buildSignOut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            Navigator.pushNamedAndRemoveUntil(
                context, '/authen', (route) => false);
          },
          tileColor: MyStyle().darkColor,
          leading: const Icon(
            Icons.exit_to_app,
            color: Colors.white,
            size: 36,
          ),
          title: MyStyle().titleH2White('Sign Out'),
          subtitle: MyStyle().titleH3White('Sign Out & Go to Authen'),
        ),
      ],
    );
  }
}
