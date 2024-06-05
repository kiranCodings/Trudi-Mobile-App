import 'package:flutter/material.dart';
import 'package:eclass/model/applied_job_model.dart';

class AppliedJobDetailsScreen extends StatefulWidget {
  final AppliedJob appliedJob;

  AppliedJobDetailsScreen({required this.appliedJob});

  @override
  _AppliedJobDetailsScreenState createState() =>
      _AppliedJobDetailsScreenState();
}

class _AppliedJobDetailsScreenState extends State<AppliedJobDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applied Job Details'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.appliedJob.jobTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${widget.appliedJob.companyName} • ${_getTimeApplied(widget.appliedJob.createdAt)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.appliedJob.image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                _stripHtmlTags(widget.appliedJob.description),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailsTile('Location', widget.appliedJob.location,
                      Icons.location_city),
                  _buildDetailsTile(
                      'Industry', widget.appliedJob.industryType, Icons.domain),
                  _buildDetailsTile(
                      'Skills', widget.appliedJob.skills.join(","), Icons.code_outlined),
                  _buildDetailsTile(
                    'Experience',
                    '${widget.appliedJob.minExperience} - ${widget.appliedJob.maxExperience} ${widget.appliedJob.experience}',
                    Icons.timeline,
                  ),
                  _buildDetailsTile(
                    'Salary',
                    '${widget.appliedJob.minSalary} - ${widget.appliedJob.maxSalary} ${widget.appliedJob.salary}',
                    Icons.attach_money_outlined,
                  ),
                  _buildDetailsTile('Employment Type',
                      widget.appliedJob.employmentType.join(","), Icons.work_outline),
                  _buildDetailsTile(
                      'Requirements',
                      widget.appliedJob.requirement,
                      Icons.check_circle_outline),
                  _buildDetailsTile('Job Role', widget.appliedJob.role,
                      Icons.business_center),
                  _buildDetailsTile('Education', widget.appliedJob.education.join(","), Icons.school),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: _getStatusColor(widget.appliedJob.status),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatusIcon(widget.appliedJob.status),
            Text(
              _getStatusText(widget.appliedJob.status),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '1':
        return Color(0xFFFFB4B4); // Light Red
      case '2':
        return Color(0xFFFFE0B2); // Light Orange
      case '3':
        return Color(0xFFB9F6CA); // Light Green
      default:
        return Colors.grey[300]!; // Light Grey
    }
  }

  Widget _buildStatusIcon(String status) {
    IconData iconData;
    Color iconColor;
    switch (status) {
      case '1':
        iconData = Icons.cancel;
        iconColor = Colors.red;
        break;
      case '2':
        iconData = Icons.hourglass_bottom;
        iconColor = Colors.orange;
        break;
      case '3':
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        break;
      default:
        iconData = Icons.help_outline;
        iconColor = Colors.grey;
        break;
    }
    return Icon(
      iconData,
      color: iconColor,
      size: 32,
    );
  }

  Widget _buildDetailsTile(String title, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.blue, // Adjust icon color
            size: 20,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black, // Adjust text color
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeApplied(DateTime appliedAt) {
    final now = DateTime.now();
    final difference = now.difference(appliedAt);
    final differenceInDays = difference.inDays;
    final differenceInMonths = (differenceInDays / 30).floor();
    final differenceInYears = (differenceInDays / 365).floor();

    if (differenceInYears > 0) {
      return '${differenceInYears} year${differenceInYears > 1 ? 's' : ''} ago';
    } else if (differenceInMonths > 0) {
      return '${differenceInMonths} month${differenceInMonths > 1 ? 's' : ''} ago';
    } else {
      return '${differenceInDays} day${differenceInDays > 1 ? 's' : ''} ago';
    }
  }

  String _stripHtmlTags(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  String _getStatusText(String status) {
    switch (status) {
      case '1':
        return 'Rejected';
      case '2':
        return 'Shortlisted';
      case '3':
        return 'Hired';
      default:
        return 'Unknown';
    }
  }
}
