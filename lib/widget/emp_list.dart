import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mcmtimecards/config.dart';
import 'package:mcmtimecards/database/employee_api.dart';
import 'package:mcmtimecards/models/employee_model.dart';
import 'package:mcmtimecards/utility/my_style.dart';
import 'package:mcmtimecards/widget/register.dart';
import 'package:mcmtimecards/widget/time_card.dart';
import 'package:mcmtimecards/widget/time_card_report.dart';

// ignore: must_be_immutable
class EmployeeList extends StatefulWidget {
  // ignore: non_constant_identifier_names
  String select_cmd, header;
  EmployeeList(this.select_cmd, this.header, {Key key}) : super(key: key);

  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  Future<List<Employee>> employees;

  @override
  void initState() {
    super.initState();
    employees = EmployeeAPI().loadAllEmployee();
  }

  void refreshData() async {
    setState(() {
      employees = EmployeeAPI().loadAllEmployee();
    });
  }

  @override
  Widget build(BuildContext context) {
    final int year = DateTime.now().year;
    final int month = DateTime.now().month;
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(widget.header)),
          backgroundColor: widget.select_cmd == "register"
              ? MyStyle().darkColor
              : widget.select_cmd == "approv_ot"
                  ? MyStyle().primaryColor
                  : MyStyle().lightColor,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh),
              color: Colors.white,
              onPressed: () {
                refreshData();
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Employee>>(
          future: employees,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var employee = snapshot.data[index];
                    return Card(
                      elevation: 10.0,
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        onTap: () {},
                        leading: CircleAvatar(
                          backgroundColor: Colors.lightBlue,
                          backgroundImage: (employee.urlImage == "" ||
                                  employee.urlImage == null ||
                                  employee.urlImage == employee.employeeId ||
                                  employee.urlImage == null)
                              ? null
                              : NetworkImage(
                                  AppConfig().url + employee.urlImage),
                        ),
                        title:
                            Text('${employee.firstName} ${employee.lastName}'),
                        subtitle: Text('Mac Address: ${employee.macAddress}'),
                        trailing: IconButton(
                          icon: widget.select_cmd == "register"
                              ? const Icon(Icons.edit)
                              : widget.select_cmd == "approv_ot"
                                  ? const Icon(Icons.more_time)
                                  : widget.select_cmd == "timecard"
                                      ? const Icon(Icons.access_time)
                                      : const Icon(Icons.info),
                          onPressed: () {
                            switch (widget.select_cmd) {
                              case "register":
                                Register.employeeid = employee.employeeId;
                                Register.name = employee.firstName +
                                    ' ' +
                                    employee.lastName;
                                Register.urlImage = employee.urlImage;
                                Register.macaddress = employee.macAddress;
                                Navigator.pushNamed(context, '/register');
                                break;

                              case "approv_ot":
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => TimeCardReport(
                                        employee.employeeId, year, month, true),
                                  ),
                                );
                                break;

                              case "report":
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => TimeCardReport(
                                        employee.employeeId,
                                        year,
                                        month,
                                        false),
                                  ),
                                );
                                break;
                              case "timecard":
                                TimeCard.employeeid = employee.employeeId;
                                TimeCard.name = employee.firstName +
                                    ' ' +
                                    employee.lastName;
                                Navigator.pushNamed(context, '/timecard');
                                break;
                              default:
                            }
                          },
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
