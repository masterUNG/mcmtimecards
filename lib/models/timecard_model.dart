class TimeCardModel {
  int id;
  String employeeid;
  DateTime starttime;
  DateTime endtime;
  double otx1;
  double otx1_5;
  double otx2;
  double otx3;
  String otapprover;
  String wifibssidin;
  String wifibssidout;
  String note;
  TimeCardModel(
      {this.id,
      this.employeeid,
      this.starttime,
      this.endtime,
      this.otx1,
      this.otx1_5,
      this.otx2,
      this.otx3,
      this.otapprover,
      this.wifibssidin,
      this.wifibssidout,
      this.note});
}
