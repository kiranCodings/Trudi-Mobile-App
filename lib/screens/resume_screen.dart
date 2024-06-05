import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eclass/provider/resume_provider.dart';
import 'package:eclass/model/resume.dart';
import 'package:eclass/screens/edit_resume_screen.dart';

class ResumeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
    resumeProvider.fetchResume(context); // Fetch resume data from API

    return Scaffold(
      appBar: AppBar(
        title: Text('Resume'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              final resume = resumeProvider.resume!;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditResumeScreen(resume: resume),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ResumeProvider>(
        builder: (context, resumeProvider, child) {
          if (resumeProvider.resume == null) {
            // Resume data is not yet loaded, so show loading indicator
            return Center(child: CircularProgressIndicator());
          } else {
            // Resume data is loaded, display it
            var resume = resumeProvider.resume!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileSection(resume),
                  SizedBox(height: 20),
                  _buildSectionTitle('Personal Information'),
                  SizedBox(height: 10),
                  _buildPersonalInfo(resume.personal),
                  SizedBox(height: 20),
                  _buildSectionTitle('Education'),
                  SizedBox(height: 10),
                  _buildEducationList(resume.education),
                  SizedBox(height: 20),
                  _buildSectionTitle('Experience'),
                  SizedBox(height: 10),
                  _buildExperienceList(resume.experiences),
                  SizedBox(height: 20),
                  _buildSectionTitle('Projects'),
                  SizedBox(height: 10),
                  _buildProjectList(resume.projects),
                  SizedBox(height: 20),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileSection(Resume resume) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(resume.personal.image),
          ),
          SizedBox(height: 10),
          Text(
            '${resume.personal.fname} ${resume.personal.lname}',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 5),
          Text(
            resume.personal.profession,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF21b789), Color(0xFF2f73ba)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfo(Personal personal) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black45,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildInfoRow(Icons.business, 'Working At', personal.workingAt),
            // Divider(),
            _buildInfoRow(Icons.flag, 'Country', personal.countryName ?? ''),
            Divider(),
            _buildInfoRow(Icons.location_on, 'State', personal.stateName ?? ''),
            Divider(),
            _buildInfoRow(Icons.location_city, 'City', personal.city),
            Divider(),
            _buildInfoRow(Icons.home, 'Address', personal.address),
            Divider(),
            _buildInfoRow(Icons.phone, 'Phone', personal.phone),
            Divider(),
            _buildInfoRow(Icons.email, 'Email', personal.email),
            Divider(),
            // _buildInfoRow(Icons.cake, 'DOB', personal.dob ?? ''),
            _buildInfoRow(Icons.star, 'Skills', personal.skill),
            Divider(),
            _buildInfoRow(Icons.favorite, 'Interest', personal.interest),
            Divider(),
            _buildInfoRow(Icons.fitness_center, 'Strength', personal.strength),
            Divider(),
            _buildInfoRow(Icons.emoji_objects, 'Objective', personal.objective),
            Divider(),
            _buildInfoRow(Icons.language, 'Language', personal.language),
          ],
        ),
      ),
    );
  }
Widget _buildInfoRow(IconData icon, String label, dynamic value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Color(0xFF21b789)), // Brand color
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF21b789), // Brand color
              ),
            ),
          ],
        ),
        Expanded(
          child: value is List
              ? Wrap(
                  spacing: 4.0,
                  children: (value as List<String>)
                      .map((skill) => Chip(label: Text(skill)))
                      .toList(),
                )
              : Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
        ),
      ],
    ),
  );
}

  Widget _buildEducationList(List<Education> educationList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: educationList.map((education) {
        return _buildEducationRow(education);
      }).toList(),
    );
  }

  Widget _buildEducationRow(Education education) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black45,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.book, 'Course', education.course),
            Divider(),
            _buildInfoRow(Icons.school, 'School', education.school),
            Divider(),
            _buildInfoRow(Icons.grade, 'Marks', education.marks),
            Divider(),
            _buildInfoRow(Icons.calendar_today, 'Year of Passing',
                education.yearOfPassing),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceList(List<Experience> experienceList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: experienceList.map((experience) {
        return _buildExperienceRow(experience);
      }).toList(),
    );
  }

  Widget _buildExperienceRow(Experience experience) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black45,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.work, 'Job Title', experience.jobTitle),
            Divider(),
            _buildInfoRow(
                Icons.business_center, 'Employer', experience.employer),
            Divider(),
            _buildInfoRow(Icons.location_city, 'City', experience.city),
            Divider(),
            _buildInfoRow(Icons.location_on, 'State', experience.state),
            Divider(),
            _buildInfoRow(
                Icons.calendar_today, 'Start Date', experience.startDate),
            Divider(),
            _buildInfoRow(Icons.calendar_today, 'End Date', experience.endDate),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectList(List<Project> projectList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: projectList.map((project) {
        return _buildProjectRow(project);
      }).toList(),
    );
  }

  Widget _buildProjectRow(Project project) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black45,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
                Icons.assignment, 'Project Title', project.projectTitle),
            Divider(),
            _buildInfoRow(Icons.person, 'Role', project.role),
            Divider(),
            _buildInfoRow(
                Icons.description, 'Description', project.description),
          ],
        ),
      ),
    );
  }
}
