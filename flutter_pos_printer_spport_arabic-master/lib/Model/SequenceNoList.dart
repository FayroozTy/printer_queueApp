// To parse this JSON data, do
//
//     final sequenceNoList = sequenceNoListFromJson(jsonString);

import 'dart:convert';

SequenceNoList sequenceNoListFromJson(String str) => SequenceNoList.fromJson(json.decode(str));

String sequenceNoListToJson(SequenceNoList data) => json.encode(data.toJson());

class SequenceNoList {
  SequenceNoList({
    this.errorDesc,
    required this.resultObject,
    required this.status,
  });

  dynamic errorDesc;
  ResultObjectS resultObject;
  String status;

  factory SequenceNoList.fromJson(Map<String, dynamic> json) => SequenceNoList(
    errorDesc: json["Error_Desc"],
    resultObject: ResultObjectS.fromJson(json["Result_Object"]),
    status: json["Status"],
  );

  Map<String, dynamic> toJson() => {
    "Error_Desc": errorDesc,
    "Result_Object": resultObject.toJson(),
    "Status": status,
  };
}

class ResultObjectS {
  ResultObjectS({
    required this.timeStamp,
    required this.queingSequenceNo,
  });

  String timeStamp;
  int queingSequenceNo;

  factory ResultObjectS.fromJson(Map<String, dynamic> json) => ResultObjectS(
    timeStamp: json["TimeStamp"],
    queingSequenceNo: json["Queing_Sequence_No"],
  );

  Map<String, dynamic> toJson() => {
    "TimeStamp": timeStamp,
    "Queing_Sequence_No": queingSequenceNo,
  };
}
