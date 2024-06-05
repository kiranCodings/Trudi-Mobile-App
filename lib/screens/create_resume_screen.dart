import 'dart:convert';
import 'dart:io';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:eclass/provider/resume_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CreateResumeScreen extends StatefulWidget {
  @override
  _CreateResumeScreenState createState() => _CreateResumeScreenState();
}

class _CreateResumeScreenState extends State<CreateResumeScreen> {
  final picker = ImagePicker();
  File? _image;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  String firstName = '';
  String lastName = '';
  String profession = '';
  String? country;
  String? state;
  String city = '';
  String address = '';
  String phone = '';
  String email = '';
  List<String> skillList = [];
  String strength = '';
  String interest = '';
  String language = '';
  String objective = '';

  List<Map<String, String>> educationList = [];
  List<Map<String, String>> experienceList = [];
  List<Map<String, String>> projectList = [];

  List<Map<String, dynamic>> countries = [];
  List<Map<String, dynamic>> states = [];

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final resumeProvider =
          Provider.of<ResumeProvider>(context, listen: false);

      setState(() {
        _isLoading = true;
      });
      resumeProvider
          .submitResume(
        context: context,
        firstName: firstName,
        lastName: lastName,
        profession: profession,
        country: country!,
        state: state!,
        city: city,
        address: address,
        phone: phone,
        email: email,
        skill: skillList,
        strength: strength,
        interest: interest,
        language: language,
        objective: objective,
        educationList: educationList,
        experienceList: experienceList,
        projectList: projectList,
        image: _image,
      )
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Resume submitted successfully')),
        );
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit resume: $error')),
        );
        setState(() {
          _isLoading = false;
        });
      });
    }
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
  void initState() {
    super.initState();
    fetchCountryAndStateDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Resume')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: getImage,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  _image != null ? FileImage(_image!) : null,
                              child: _image == null
                                  ? Icon(Icons.add_a_photo)
                                  : null,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Divider(color: Colors.black),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      'Profile',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildSectionTitle('Personal Information'),
                    _buildTextField(
                        'First Name', (value) => firstName = value, true),
                    _buildTextField(
                        'Last Name', (value) => lastName = value, true),
                    _buildTextField(
                        'Profession', (value) => profession = value, true),
                    SizedBox(height: 20),
                    _buildSectionTitle('Contact Information'),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(labelText: 'Country'),
                      value: country == null
                          ? null
                          : countries.firstWhere(
                              (c) => c['country_id'].toString() == country,
                              orElse: () => {})['country_id'],
                      onChanged: (value) {
                        setState(() {
                          country = value.toString();
                          // Clear the selected state when a new country is selected
                          state = null;
                        });
                      },
                      items: countries.map((Map<String, dynamic> country) {
                        return DropdownMenuItem<int>(
                          value: country['country_id'],
                          child: Text(country['nicename']),
                        );
                      }).toList(),
                    ),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(labelText: 'State'),
                      value: state == null
                          ? null
                          : states.firstWhere(
                              (s) => s['state_id'].toString() == state,
                              orElse: () => {})['state_id'],
                      onChanged: (value) {
                        setState(() {
                          state = value.toString();
                        });
                      },
                      items: country == null
                          ? []
                          : states
                              .where((Map<String, dynamic> s) =>
                                  s['country_id'] ==
                                  countries.firstWhere((c) =>
                                      c['country_id'].toString() ==
                                      country)['country_id'])
                              .map((Map<String, dynamic> state) {
                              return DropdownMenuItem<int>(
                                value: state[
                                    'state_id'], // Ensure each value is unique
                                child: Text(state['name']),
                              );
                            }).toList(),
                    ),
                    _buildTextField('City', (value) => city = value, true),
                    _buildTextField(
                        'Address', (value) => address = value, true),
                    _buildTextField('Phone', (value) => phone = value, true,
                        keyboardType: TextInputType.phone),
                    _buildTextField('Email', (value) => email = value, true),
                    SizedBox(height: 20),
                    _buildSectionTitle('Skills'),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: skillList.map((skill) {
                        return Chip(
                          label: Text(skill),
                          onDeleted: () {
                            setState(() {
                              skillList.remove(skill);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Add Skill'),
                      onFieldSubmitted: (value) {
                        // Trim leading and trailing spaces from the input value
                        final trimmedValue = value.trim();
                        // Remove any special characters or spaces from the trimmed input value
                        final validInput = trimmedValue.replaceAll(
                            RegExp(r'[^a-zA-Z0-9]'), '');
                        if (validInput.isNotEmpty) {
                          setState(() {
                            skillList.add(validInput);
                          });
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    _buildSectionTitle('Objective'),
                    _buildTextField(
                      'Objective',
                      (value) => objective = value,
                      true,
                    ),
                    SizedBox(height: 20),
                    _buildSectionTitle('Strengths'),
                    _buildTextField(
                      'Strengths',
                      (value) => strength = value,
                      true,
                    ),
                    SizedBox(height: 20),
                    _buildSectionTitle('Interests'),
                    _buildTextField(
                      'Interests',
                      (value) => interest = value,
                      true,
                    ),
                    SizedBox(height: 20),
                    _buildSectionTitle('Languages'),
                    _buildTextField(
                        'Languages', (value) => language = value, true),
                    SizedBox(height: 20),
                    _buildSectionTitle('Education'),
                    _buildDynamicRows(educationList, 'Add Education',
                        ['Degree', 'School/College', 'Marks', 'Passing Out']),
                    SizedBox(height: 20),
                    _buildSectionTitle('Experience'),
                    _buildDynamicRows(experienceList, 'Add Experience', [
                      'Job Title',
                      'Company',
                      'City',
                      'State',
                      'Start Date',
                      'End Date'
                    ]),
                    SizedBox(height: 20),
                    _buildSectionTitle('Projects'),
                    _buildDynamicRows(projectList, 'Add Project',
                        ['Project Title', 'Role', 'Description']),
                    SizedBox(height: 20),
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

  Widget _buildTextField(
      String label, Function(String) onChanged, bool isRequired,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    // Add keyboardType parameter with default value
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
      validator: isRequired
          ? (value) =>
              value == null || value.isEmpty ? 'This field is required' : null
          : null,
      maxLines: maxLines,
      keyboardType: keyboardType, // Set keyboardType
    );
  }

  Widget _buildDropdownField(String label, List<Map<String, dynamic>> items,
      Function(dynamic) onChanged) {
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: label),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item['id'],
          child: Text(item['name']),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'This field is required' : null,
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
              for (int j = 0; j < fieldNames.length; j++)
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: fieldNames[j]),
                    initialValue: dataList[i][fieldNames[j]] ?? '',
                    onChanged: (value) => dataList[i][fieldNames[j]] = value,
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
              dataList.add({for (var field in fieldNames) field: ''});
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
}
