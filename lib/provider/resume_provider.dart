// resume_provider.dart
import 'dart:convert';
import 'dart:io';

import 'package:eclass/screens/resume_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:eclass/model/resume.dart';

class ResumeProvider extends ChangeNotifier {
  Resume? _resume;
  Resume? get resume => _resume;

  Future<void> fetchResume(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse("${APIData.myResumeView}${APIData.secretKey}"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );

      print(response.body);
      print("kiran");
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final personalData = jsonResponse['Data'];
        final resume = Resume.fromJson(personalData);
        setResume(resume);
      } else if (response.statusCode == 409 &&
          response.body.contains('Create Resume')) {
        Navigator.pushReplacementNamed(context, "/createresume");
      } else {
        throw Exception('Failed to load resume');
      }
    } catch (e) {
      throw Exception('Failed to load resume: $e');
    }
  }

  Future<void> submitResume({
    required BuildContext context, // Add BuildContext parameter
    required String firstName,
    required String lastName,
    required String profession,
    required String country,
    required String state,
    required String city,
    required String address,
    required String phone,
    required String email,
    required List<String> skill,
    required String strength,
    required String interest,
    required String language,
    required String objective,
    required List<Map<String, String>> educationList,
    required List<Map<String, String>> experienceList,
    required List<Map<String, String>> projectList,
    required File? image,
  })
    
   async {
    try {
      // Construct the form data
      final formData = {
        'fname': firstName,
        'lname': lastName,
        'profession': profession,
        'country': country,
        'state': state,
        'city': city,
        'address': address,
        'phone': phone,
        'email': email,
        'skill': jsonEncode(skill),
        'strength': strength,
        'interest': interest,
        'language': language,
        'objective': objective,
        'educationList': jsonEncode(educationList),
        'experienceList': jsonEncode(experienceList),
        'projectList': jsonEncode(projectList),
      };
      print(formData);
      // Create a separate map for multipart/form-data fields
      final multipartData = Map<String, http.MultipartFile?>();

      // Add image file to the multipart data if available

      String url = "${APIData.createResume}?secret=${APIData.secretKey}";
      // Send the form data to the API
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers[HttpHeaders.authorizationHeader] = "Bearer $authToken";
      request.fields.addAll(formData);
      multipartData.forEach((key, value) {
        if (value != null) {
          request.files.add(value);
        }
      });
      if (image != null) {
        // Create a multipart file from the image file
        final imageFile = await http.MultipartFile.fromPath(
          'photo',
          image.path,
          filename: image.path.split('/').last,
        );

        // Add the image file to the multipart request
        request.files.add(imageFile);
      }

      final response = await request.send();
// Read the streamed response and convert it to a string
      final responseString = await response.stream.bytesToString();
      print(responseString);
      if (response.statusCode == 200) {
        // Resume submitted successfully
        print('Resume submitted successfully');
        // Navigate to the view resume screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ResumeScreen()),
        );
      } else {
        throw Exception('Failed to submit resume');
      }
    } catch (e) {
      throw Exception('Failed to submit resume: $e');
    }
  }

  Future<void> editResume({
    required BuildContext context, // Add BuildContext parameter
    required String firstName,
    required String lastName,
    required String profession,
    required String country,
    required String state,
    required String city,
    required String address,
    required String phone,
    required String email,
    required List<String> skill,
    required String strength,
    required String interest,
    required String language,
    required String objective,
    required List<Map<String, String>> educationList,
    required List<Map<String, String>> experienceList,
    required List<Map<String, String>> projectList,
    required File? image,
  }) async {
    try {
      // Construct the form data
      final formData = {
        'fname': firstName,
        'lname': lastName,
        'profession': profession,
        'country': country,
        'state': state,
        'city': city,
        'address': address,
        'phone': phone,
        'email': email,
        'skill': jsonEncode(skill),
        'strength': strength,
        'interest': interest,
        'language': language,
        'objective': objective,
        'educationList': jsonEncode(educationList),
        'experienceList': jsonEncode(experienceList),
        'projectList': jsonEncode(projectList),
      };
      print(formData);
      // Create a separate map for multipart/form-data fields
      final multipartData = Map<String, http.MultipartFile?>();

      // Add image file to the multipart data if available
      String url = "${APIData.editResume}?secret=${APIData.secretKey}";
      print(url);
      // Send the form data to the API
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers[HttpHeaders.authorizationHeader] = "Bearer $authToken";
      
      request.fields.addAll(formData);
      multipartData.forEach((key, value) {
        if (value != null) {
          request.files.add(value);
        }
      });
      if (image != null) {
        // Create a multipart file from the image file
        final imageFile = await http.MultipartFile.fromPath(
          'photo',
          image.path,
          filename: image.path.split('/').last,
        );

        // Add the image file to the multipart request
        request.files.add(imageFile);
      }

      final response = await request.send();
      // Read the streamed response and convert it to a string
      final responseString = await response.stream.bytesToString();
      print("printing edit:$responseString");
      if (response.statusCode == 200) {
        // Resume submitted successfully
        print('Resume submitted successfully');
        // Navigate to the view resume screen
        await fetchResume(context);
      } else {
        throw Exception('Failed to submit resume');
      }
    } catch (e) {
      throw Exception('Failed to submit resume: $e');
    }
  }

  void setResume(Resume resume) {
    _resume = resume;
    notifyListeners();
  }
}
