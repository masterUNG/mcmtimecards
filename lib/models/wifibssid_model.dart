import 'dart:convert';

WifiBssidModel wifiBssidModelFromJson(String str) =>
    WifiBssidModel.fromJson(json.decode(str));

String wifiBssidModelToJson(WifiBssidModel data) => json.encode(data.toJson());

class WifiBssidModel {
  WifiBssidModel({this.data});
  List<Wifibssid> data;

  factory WifiBssidModel.fromJson(Map<String, dynamic> json) => WifiBssidModel(
        data: json["data"] == null
            ? null
            : List<Wifibssid>.from(
                json["data"].map((x) => Wifibssid.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((e) => e.toJson())),
      };
}

class Wifibssid {
  Wifibssid({this.wifibssid});

  String wifibssid;

  factory Wifibssid.fromJson(Map<String, dynamic> json) =>
      Wifibssid(wifibssid: json["wifi_bssid"]);

  Map<String, dynamic> toJson() => {"wifi_bssid": wifibssid};

  // ignore: non_constant_identifier_names
  static Map<String, dynamic> to_Json(Wifibssid wif) {
    return {'wifi_bssid': wif.wifibssid};
  }
}
