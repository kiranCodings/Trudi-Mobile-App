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

  Future<void> fetchJobsWithFilters({
    List<dynamic>? locations,
    List<dynamic>? skills,
    List<dynamic>? roles,
    List<dynamic>? industries,
    List<dynamic>? educations,
  }) async {
    try {
      Uri uri = Uri.parse(APIData.jobFilter);
      print(uri);
      Map<String, String> queryParams = {
        'secret': APIData.secretKey,
      };

      if (locations != null && locations.isNotEmpty) {
        queryParams['location'] = jsonEncode(locations);
      }
      if (skills != null && skills.isNotEmpty) {
        queryParams['skills'] = jsonEncode(skills);
      }
      if (roles != null && roles.isNotEmpty) {
        queryParams['roles'] = jsonEncode(roles);
      }
      if (industries != null && industries.isNotEmpty) {
        queryParams['industries'] = jsonEncode(industries);
      }
      if (educations != null && educations.isNotEmpty) {
        queryParams['educations'] = _buildJsonArray(educations);
      }

      uri = uri.replace(queryParameters: queryParams);

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
        final List<dynamic> jobList = jsonResponse['List of Jobs'];
        _jobs = jobList.map((jobJson) => Job.fromJson(jobJson)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      throw Exception('Failed to load jobs: $e');
    }
  }

  String _buildJsonArray(List<dynamic> items) {
    // Convert each item to a string enclosed in double quotes
    List<String> formattedItems = items.map((item) => '"$item"').toList();
    // Join the items into a JSON array string
    return '[' + formattedItems.join(',') + ']';
  }
}
