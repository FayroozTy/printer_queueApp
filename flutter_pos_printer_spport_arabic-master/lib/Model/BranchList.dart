// To parse this JSON data, do
//
//     final branchList = branchListFromJson(jsonString);

import 'dart:convert';

BranchList branchListFromJson(String str) => BranchList.fromJson(json.decode(str));

String branchListToJson(BranchList data) => json.encode(data.toJson());

class BranchList {
  BranchList({
    this.errorDesc,
    required this.resultObject,
    required this.status,
  });

  dynamic errorDesc;
  List<ResultObject> resultObject;
  String status;

  factory BranchList.fromJson(Map<String, dynamic> json) => BranchList(
    errorDesc: json["Error_Desc"],
    resultObject: List<ResultObject>.from(json["Result_Object"].map((x) => ResultObject.fromJson(x))),
    status: json["Status"],
  );

  Map<String, dynamic> toJson() => {
    "Error_Desc": errorDesc,
    "Result_Object": List<dynamic>.from(resultObject.map((x) => x.toJson())),
    "Status": status,
  };
}

class ResultObject {
  ResultObject({
    required this.queingBranchId,
    required this.queingBranchDesc,
  });

  int queingBranchId;
  String queingBranchDesc;

  factory ResultObject.fromJson(Map<String, dynamic> json) => ResultObject(
    queingBranchId: json["Queing_Branch_ID"],
    queingBranchDesc: json["Queing_Branch_Desc"],
  );

  Map<String, dynamic> toJson() => {
    "Queing_Branch_ID": queingBranchId,
    "Queing_Branch_Desc": queingBranchDesc,
  };
}
