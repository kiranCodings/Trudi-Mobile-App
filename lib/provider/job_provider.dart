import 'dart:convert';
import 'package:eclass/common/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:eclass/common/apidata.dart';
import 'package:eclass/model/job.dart'; // Import your Job model

class JobProvider with ChangeNotifier {
  List<Job> _jobs = [];

  List<Job> get jobs => _jobs;

  Future<void> fetchJobs({String? query}) async {
    try {
      Uri uri = Uri.parse("${APIData.jobListing}${APIData.secretKey}");
      if (query != null) {
        uri = Uri.parse(
            "${APIData.jobListing}${APIData.secretKey}&search=$query");
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
        final List<dynamic> jobList = jsonResponse['Job'];
        _jobs = jobList.map((jobJson) => Job.fromJson(jobJson)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      throw Exception('Failed to load jobs: $e');
    }
  }
}
