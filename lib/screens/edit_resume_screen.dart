import 'dart:convert';
import 'dart:io';

import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:eclass/provider/resume_provider.dart';
import 'package:eclass/model/resume.dart';

class EditResumeScreen extends StatefulWidget {
  final Resume resume; // Define the named parameter 'resume'

  EditResumeScreen({required this.resume}); // Constructor

  @override
  _EditResumeScreenState createState() => _EditResumeScreenState();
}

class _EditResumeScreenState extends State<EditResumeScreen> {
  late ResumeProvider _resumeProvider;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _professionController;
  late TextEditingController _countryController;
  late TextEditingController _stateController;
  late TextEditingController _cityController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _skillController;
  late TextEditingController _strengthController;
  late TextEditingController _interestController;
  late TextEditingController _languageController;
  late TextEditingController _objectiveController;
  List<Map<String, String>> _education = [];
  List<Map<String, String>> _works = [];
  List<Map<String, String>> _project = [];
  List<Map<String, dynamic>> countries = [];
  List<Map<String, dynamic>> states = [];
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
    final resume = _resumeProvider.resume!;
    _firstNameController = TextEditingController(text: resume.personal.fname);
    _lastNameController = TextEditingController(text: resume.personal.lname);
    _professionController =
        TextEditingController(text: resume.personal.profession);
    _countryController = TextEditingController(text: resume.personal.country);
    _stateController = TextEditingController(text: resume.personal.state);
    _cityController = TextEditingController(text: resume.personal.city);
    _addressController = TextEditingController(text: resume.personal.address);
    _phoneController = TextEditingController(text: resume.personal.phone);
    _emailController = TextEditingController(text: resume.personal.email);
    _skillController = TextEditingController(text: resume.personal.skill);
    _strengthController = TextEditingController(text: resume.personal.strength);
    _interestController = TextEditingController(text: resume.personal.interest);
    _languageController = TextEditingController(text: resume.personal.language);
    _objectiveController =
        TextEditingController(text: resume.personal.objective);
    _education = resume.education
        .map((education) => {
              'Degree': education.course,
              'School/College': education.school,
              'Marks': education.marks,
              'Passing Out': education.yearOfPassing,
            })
        .toList();

    _works = resume.experiences
        .map((experience) => {
              'Job Title': experience.jobTitle,
              'Company': experience.employer,
              'City': experience.city,
              'State': experience.state,
              'Start Date': experience.startDate,
              'End Date': experience.endDate,
            })
        .toList();

    _project = resume.projects
        .map((project) => {
              'Project Title': project.projectTitle,
              'Role': project.role,
              'Description': project.description,
            })
        .toList();
    _image = File(resume.personal.image);
    fetchCountryAndStateDetails();
  }

  Future<void> fetchCountryAndStateDetails() async {
    try {
      Uri uri = Uri.parse("${APIData.countrystatedetails}${APIData.secretKey}");
      http.Response response = await http.get(
        uri,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body)['Data'];
        setState(() {
          countries = List<Map<String, dynamic>>.from(data['countries']);
          states = List<Map<String, dynamic>>.from(data['state']);
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error fetching country and state details: $error');
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _professionController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _skillController.dispose();
    _strengthController.dispose();
    _interestController.dispose();
    _languageController.dispose();
    _objectiveController.dispose();
    super.dispose();
  }

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitForm(BuildContext context) {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final profession = _professionController.text.trim();
    final country = _countryController.text.trim();
    final state = _stateController.text.trim();
    final city = _cityController.text.trim();
    final address = _addressController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final skill = _skillController.text.trim();
    final strength = _strengthController.text.trim();
    final interest = _interestController.text.trim();
    final language = _languageController.text.trim();
    final objective = _objectiveController.text.trim();
    bool isImageChanged =
        _image != null && _image!.path != widget.resume.personal.image;
    bool isEducationChanged = !listEquals(_education, widget.resume.education);
    bool isExperienceChanged = !listEquals(_works, widget.resume.experiences);
    bool isProjectChanged = !listEquals(_project, widget.resume.projects);

    _resumeProvider
        .editResume(
      context: context,
      firstName: firstName,
      lastName: lastName,
      profession: profession,
      country: country,
      state: state,
      city: city,
      address: address,
      phone: phone,
      email: email,
      skill: skill,
      strength: strength,
      interest: interest,
      language: language,
      objective: objective,
      educationList: isEducationChanged ? _education : [],
      experienceList: isExperienceChanged ? _works : [],
      projectList: isProjectChanged ? _project : [],
      image: isImageChanged ? _image : null,
    )
        .then((_) {
      // Handle successful resume submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resume submitted successfully')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      // Handle error during resume submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit resume: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Resume'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _getImage,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _image != null
                          ? _isImageUrl(_image!.path)
                              ? NetworkImage(_image!.path) as ImageProvider
                              : FileImage(_image!) as ImageProvider
                          : null,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Profile',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Personal Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
              onChanged: (value) =>
                  setState(() => _firstNameController.text = value),
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
              onChanged: (value) =>
                  setState(() => _lastNameController.text = value),
            ),
            TextFormField(
              controller: _professionController,
              decoration: InputDecoration(labelText: 'Profession'),
              onChanged: (value) =>
                  setState(() => _professionController.text = value),
            ),
            // Add other fields similarly
            SizedBox(height: 20),
            Text(
              'Contact Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Country'),
              value: _countryController.text.isNotEmpty
                  ? _countryController.text
                  : null, // Set value to null if empty
              onChanged: (value) {
                setState(() {
                  _countryController.text = value!;
                  // Clear the selected state when a new country is selected
                  _stateController.text = '';
                });
              },
              items: countries.map((country) {
                return DropdownMenuItem<String>(
                  value: country['country_id'].toString(),
                  child: Text(country['nicename']),
                );
              }).toList(),
            ),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'State'),
              value: _stateController.text.isNotEmpty
                  ? _stateController.text
                  : null, // Set value to null if empty
              onChanged: (value) {
                setState(() {
                  _stateController.text = value!;
                });
              },
              items: _countryController.text.isNotEmpty
                  ? states
                      .where((s) =>
                          s['country_id'].toString() == _countryController.text)
                      .map((state) {
                      return DropdownMenuItem<String>(
                        value: state['state_id'].toString(),
                        child: Text(state['name']),
                      );
                    }).toList()
                  : [],
            ),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'City'),
              onChanged: (value) {
                setState(() => _cityController.text = value);
              },
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
              onChanged: (value) {
                setState(() => _addressController.text = value);
              },
            ),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.number, // Set the keyboardType to number
              onChanged: (value) {
                setState(() => _phoneController.text = value);
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                setState(() => _emailController.text = value);
              },
            ),
            SizedBox(height: 20),
            Text(
              'Skills',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _skillController,
              decoration: InputDecoration(labelText: 'Skills'),
              onChanged: (value) {
                setState(() => _skillController.text = value);
              },
            ),
            SizedBox(height: 20),
            Text(
              'Objective',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _objectiveController,
              decoration: InputDecoration(labelText: 'Objective'),
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  setState(() => _objectiveController.text = value);
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Strengths',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _strengthController,
              decoration: InputDecoration(labelText: 'Strengths'),
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  setState(() => _strengthController.text = value);
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Interests',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _interestController,
              decoration: InputDecoration(labelText: 'Interests'),
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  setState(() => _interestController.text = value);
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Languages',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _languageController,
              decoration: InputDecoration(labelText: 'Languages'),
              onChanged: (value) {
                setState(() {
                  setState(() => _languageController.text = value);
                });
              },
            ),
            SizedBox(height: 20),
            _buildSectionTitle('Education'),
            _buildDynamicRows(_education, 'Add Education', [
              'Degree',
              'School/College',
              'Marks',
              'Passing Out',
            ]),
            SizedBox(height: 20),
            _buildSectionTitle('Experience'),
            _buildDynamicRows(_works, 'Add Experience', [
              'Job Title',
              'Company',
              'City',
              'State',
              'Start Date',
              'End Date',
            ]),
            SizedBox(height: 20),
            _buildSectionTitle('Projects'),
            _buildDynamicRows(_project, 'Add Project', [
              'Project Title',
              'Role',
              'Description',
            ]),
            SizedBox(height: 20),
            // Add other sections similarly
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _submitForm(context),
                  child: Text('Submit'),
                ),
                SizedBox(width: 20),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDynamicRows(List<Map<String, String>> dataList,
      String buttonText, List<String> fieldNames) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < dataList.length; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (String fieldName in fieldNames)
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: TextEditingController(
                      text: dataList[i][fieldName],
                    )..selection = TextSelection.fromPosition(
                        TextPosition(
                            offset: dataList[i][fieldName]?.length ?? 0),
                      ),
                    decoration: InputDecoration(labelText: fieldName),
                    onChanged: (value) {
                      setState(() {
                        dataList[i][fieldName] = value;
                      });
                    },
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      setState(() {
                        dataList.removeAt(i);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        TextButton(
          onPressed: () {
            setState(() {
              Map<String, String> newRow = {};
              for (String fieldName in fieldNames) {
                newRow[fieldName] = '';
              }
              dataList.add(newRow);
            });
          },
          child: Row(
            children: [
              Icon(Icons.add),
              SizedBox(width: 5),
              Text(buttonText),
            ],
          ),
        ),
      ],
    );
  }

  bool _isImageUrl(String path) {
    // Check if the path starts with "File: '"
    if (path.startsWith("File: '")) {
      // Extract the URL from the string
      path = path.substring(7, path.length - 1);
    }

    // Check if the path starts with "file://" or "http://" or "https://"
    return path.startsWith("file://") ||
        path.startsWith("http://") ||
        path.startsWith("https://");
  }
}
