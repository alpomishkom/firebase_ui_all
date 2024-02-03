
import 'dart:convert';

List<Not> notFromJson(String str) => List<Not>.from(json.decode(str).map((x) => Not.fromJson(x)));

String notToJson(List<Not> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Not {
  String title;
  String decription;
  String dataTime;
  Not({
    required this.title,
    required this.decription,
    required this.dataTime,
  });

  factory Not.fromJson(Map<String, dynamic> json) => Not(
    title: json["title"],
    decription: json["decription"],
    dataTime: json["dataTime"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "decription": decription,
    "dataTime": dataTime,
  };
}
