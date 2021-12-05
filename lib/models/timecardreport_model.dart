import 'dart:convert';

TimeCardData timecardreportModelFromJson(String str) =>
    TimeCardData.fromJson(json.decode(str));

String timecardreportModelToJson(TimeCardData data) =>
    json.encode(data.toJson());

class TimeCardData {
  TimeCardData({this.data});
  List<DataTimeCard> data;

  factory TimeCardData.fromJson(Map<String, dynamic> json) => TimeCardData(
        data: json["data"] == null
            ? null
            : List<DataTimeCard>.from(
                json["data"].map((x) => DataTimeCard.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DataTimeCard {
  DataTimeCard({
    this.date,
    this.startTime,
    this.checkIn,    
    this.startDif,
    this.endTime,
    this.checkOut,
    this.endDif
  });
  String date;
  String startTime;
  String checkIn;
  String startDif;
  String endTime;
  String checkOut;
  String endDif;

  factory  DataTimeCard.fromJson(Map<String, dynamic> json) => DataTimeCard(
    date: json['Date'],
    startTime: json['StartTime'],
    checkIn: json['CheckIn'],
    startDif: json['StartDif'],
    endTime: json['EndTime'],
    checkOut: json['CheckOut'] ?? '',
    endDif: json['EndDif'] ?? ''
  );

  Map<String, dynamic> toJson() => {
     "date": date,
    "startTime": startTime,
    "checkIn": checkIn,
    "startDif": startDif,
    "endTime": endTime,
    "checkOut": checkOut ?? '',
    "endDif": endDif ?? ''
  };

  // ignore: non_constant_identifier_names
  static Map<String, dynamic> to_Json(DataTimeCard dat) {
    return {
        "date": dat.date,
    "startTime": dat.startTime,
    "checkIn": dat.checkIn,
    "startDif": dat.startDif,
    "endTime": dat.endTime,
    "checkOut": dat.checkOut,
    "endDif": dat.endDif
    };
  }
}
