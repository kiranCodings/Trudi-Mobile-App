import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import '../common/apidata.dart';
import '../common/global.dart';

class ApplyButton extends StatefulWidget {
  final bool isApplied;
  final int jobId;
  final Function(bool) onApplied;

  ApplyButton(
      {required this.isApplied, required this.jobId, required this.onApplied});

  @override
  _ApplyButtonState createState() => _ApplyButtonState();
}

class _ApplyButtonState extends State<ApplyButton> {
  late TextEditingController skillsController;
  late TextEditingController experienceController;
  late TextEditingController yearsController;
  File? _resume; // Change to nullable type
  bool useMyResume = false;

  @override
  void initState() {
    super.initState();
    skillsController = TextEditingController();
    experienceController = TextEditingController();
    yearsController = TextEditingController();
    _resume = null; // Initialize _resume with null
  }

  @override
  void dispose() {
    skillsController.dispose();
    experienceController.dispose();
    yearsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Set maximum width
      padding: EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () {
          widget.isApplied ? "" : _showApplyFormDialog(context);
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 8), // Adjust button padding
        ),
        child: Text(
          widget.isApplied ? 'Applied' : 'Apply',
          style: TextStyle(
            fontSize: 18,
          ), // Adjust font size
        ),
      ),
    );
  }

  void _showApplyFormDialog(BuildContext context) {
    String selectedExperience = 'Years'; // Initially selected value

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Apply for Job'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: skillsController,
                      decoration: InputDecoration(
                        labelText: 'Skills',
                      ),
                    ),
                    TextField(
                      controller: experienceController,
                      decoration: InputDecoration(
                        labelText: 'Experience',
                      ),
                      keyboardType: TextInputType.number, // Restricts input to numbers
                    ),
                    SizedBox(
                        height:
                            16), // Add space between text fields and dropdown
                    Row(
                      children: [
                        Text(
                          'Years of Experience:',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                            width: 10), // Add space between label and dropdown
                        DropdownButton<String>(
                          value: selectedExperience,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedExperience = newValue!;
                            });
                          },
                          items: <String>['Years', 'Months']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: 16), // Add padding on top of the upload button
                    Row(
                      children: [
                        Checkbox(
                          value: useMyResume,
                          onChanged: (bool? value) {
                            setState(() {
                              useMyResume = value!;
                              if (useMyResume) {
                                _resume = null;
                              }
                            });
                          },
                        ),
                        Text('Use my Trudi resume'),
                      ],
                    ),
                    if (!useMyResume)
                      ElevatedButton(
                        onPressed: _uploadResume,
                        child: Text('Upload Resume'),
                      ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _submitApplication(context, selectedExperience);
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _uploadResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _resume = File(result.files.single.path!);
      });
    } else {
      // User canceled the file picker
    }
  }

  void _submitApplication(
      BuildContext context, String selectedExperience) async {
    // Check if selected experience is correctly captured

    if (skillsController.text.isEmpty ||
        experienceController.text.isEmpty ||
        selectedExperience.isEmpty ||
        (!useMyResume && _resume == null)) {
      Fluttertoast.showToast(
        msg: 'Please fill all fields and upload resume.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    String url =
        "${APIData.applyJob}${widget.jobId}?secret=${APIData.secretKey}";

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers[HttpHeaders.authorizationHeader] = "Bearer $authToken";
    request.headers["Accept"] = "application/json";

    request.fields['skills'] = skillsController.text;
    request.fields['experiense'] = experienceController.text;
    request.fields['years'] = selectedExperience.toLowerCase();

    // Add resume file to request
    if (!useMyResume) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'pdf',
          _resume!.path,
        ),
      );
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      widget.onApplied(true);
      Fluttertoast.showToast(
        msg: 'Job applied successfully!',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.of(context).pop(); // Close the dialog after submission
    } else {
      Fluttertoast.showToast(
        msg: 'Something went wrong.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
