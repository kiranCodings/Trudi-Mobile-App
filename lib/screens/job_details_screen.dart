import 'package:eclass/widgets/apply_button.dart';
import 'package:flutter/material.dart';
import 'package:eclass/model/job.dart';

class JobDetailsScreen extends StatefulWidget {
  final Job job;

  JobDetailsScreen({required this.job});

  @override
  _JobDetailsScreenState createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  bool _isApplied = false;

  @override
  void initState() {
    super.initState();
    _isApplied =
        widget.job.isApplied; // Initialize _isApplied from job.isApplied
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.job.jobTitle, // Access job property from widget.job
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${widget.job.companyName} • ${_getTimeSincePosted(widget.job.createdAt)}', // Access job property from widget.job
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.job.image, // Access job property from widget.job
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
                      _stripHtmlTags(widget.job
                          .description), // Access job property from widget.job
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 250, 254, 255),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildDetailsTile(
                            'Location',
                            widget.job.location,
                            Icons
                                .location_city), // Access job property from widget.job
                        Divider(height: 24),
                        _buildDetailsTile(
                            'Industry',
                            widget.job.industryType,
                            Icons
                                .domain), // Access job property from widget.job
                        Divider(height: 24),
                        _buildDetailsTile(
                            'Skills',
                            widget.job.skills,
                            Icons
                                .code_outlined), // Access job property from widget.job
                        Divider(height: 24),
                        _buildDetailsTile(
                            'Experience',
                            '${widget.job.minExperience} - ${widget.job.maxExperience} ${widget.job.experience}', // Access job property from widget.job
                            Icons.timeline),
                        Divider(height: 24),
                        _buildDetailsTile(
                            'Salary',
                            '${widget.job.minSalary} - ${widget.job.maxSalary} ${widget.job.salary}', // Access job property from widget.job
                            Icons.attach_money_outlined),
                        Divider(height: 24),
                        _buildDetailsTile(
                            'Employment Type',
                            widget.job
                                .employmentType, // Access job property from widget.job
                            Icons.work_outline),
                        Divider(height: 24),
                        _buildDetailsTile(
                            'Requirements',
                            widget.job
                                .requirement, // Access job property from widget.job
                            Icons.check_circle_outline),
                        Divider(height: 24),
                        _buildDetailsTile(
                            'Job Role',
                            widget.job.role,
                            Icons
                                .business_center), // Access job property from widget.job
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ApplyButton(
            isApplied: _isApplied, // Pass _isApplied state variable
            jobId: widget.job.id, // Access job property from widget.job
            onApplied: (applied) {
              setState(() {
                _isApplied = applied;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTile(String title, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.grey[600],
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
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
    );
  }

  String _getTimeSincePosted(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
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
}
