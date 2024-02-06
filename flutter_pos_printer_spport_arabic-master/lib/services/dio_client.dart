import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../Model/BranchList.dart';
import '../Model/SequenceNoList.dart';
import '../Model/SequenceNoList.dart';
import 'logging.dart';
import 'package:http/http.dart' as http;

  Future<BranchList> GetBranchList() async {



    final url = Uri.parse('http://192.168.0.170:5146/api/Queing/BranchList');
    var response = await get(url);
    print('Status code: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');

    return branchListFromJson(response.body);



  }

// Future<SequenceNoList> GetSequenceNoList(int SequenceNo) async {
//
//
//
//   final url = Uri.parse('http://192.168.0.170:5146/api/Queing/SequenceNo/$SequenceNo');
//   var response = await get(url);
//   print('Status code: ${response.statusCode}');
//   print('Headers: ${response.headers}');
//   print('Body: ${response.body}');
//
//   return sequenceNoListFromJson(response.body);
//
//
//
// }










