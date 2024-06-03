import 'dart:convert';
import 'package:eclass/common/global.dart';
import 'package:eclass/model/applied_job_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:eclass/common/apidata.dart';

class AppliedJobProvider with ChangeNotifier {
  List<AppliedJob> _appliedJobs = [];
  List<AppliedJob> get appliedJobs => _appliedJobs;

  Future<void> fetchAppliedJobs({String? query}) async {
    try {
      Uri uri = Uri.parse("${APIData.appliedJoblist}${APIData.secretKey}");
      if (query != null) {
        uri = Uri.parse(
            "${APIData.appliedJoblist}${APIData.secretKey}&search=$query");
      }
      http.Response response = await http.get(
        uri,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic>? appliedJobList = jsonResponse['Job'];

        if (appliedJobList != null) {
          _appliedJobs = appliedJobList
              .map((jobJson) => AppliedJob.fromJson(jobJson))
              .toList();
          notifyListeners();
        } else {
          throw Exception('Invalid JSON response: data is null');
        }
      } else {
        throw Exception('Failed to load applied jobs');
      }
    } catch (e) {
      throw Exception('Failed to load applied jobs: $e');
    }
  }
}
