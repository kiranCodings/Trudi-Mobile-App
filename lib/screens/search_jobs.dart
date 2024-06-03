import 'package:flutter/material.dart';

class SearchJobs extends StatefulWidget {
  @override
  _SearchJobsState createState() => _SearchJobsState();
}

class _SearchJobsState extends State<SearchJobs> {
  List<Job> jobList = [
    Job(
      title: "Flutter Developer",
      company: "ABC Company",
      location: "New York",
      salary: 80000,
    ),
    Job(
      title: "Software Engineer",
      company: "XYZ Inc.",
      location: "San Francisco",
      salary: 90000,
    ),
    Job(
      title: "Flutter Developer",
      company: "ABC Company",
      location: "New York",
      salary: 80000,
    ),
    Job(
      title: "Software Engineer",
      company: "XYZ Inc.",
      location: "San Francisco",
      salary: 90000,
    ),
    Job(
      title: "Flutter Developer",
      company: "ABC Company",
      location: "New York",
      salary: 80000,
    ),
    Job(
      title: "Software Engineer",
      company: "XYZ Inc.",
      location: "San Francisco",
      salary: 90000,
    ),
    Job(
      title: "Flutter Developer",
      company: "ABC Company",
      location: "New York",
      salary: 80000,
    ),
    Job(
      title: "Software Engineer",
      company: "XYZ Inc.",
      location: "San Francisco",
      salary: 90000,
    ),
    Job(
      title: "Flutter Developer",
      company: "ABC Company",
      location: "New York",
      salary: 80000,
    ),
    Job(
      title: "Software Engineer",
      company: "XYZ Inc.",
      location: "San Francisco",
      salary: 90000,
    ),
    Job(
      title: "Flutter Developer",
      company: "ABC Company",
      location: "New York",
      salary: 80000,
    ),
    Job(
      title: "Software Engineer",
      company: "XYZ Inc.",
      location: "San Francisco",
      salary: 90000,
    ),
    Job(
      title: "Flutter Developer",
      company: "ABC Company",
      location: "New York",
      salary: 80000,
    ),
    Job(
      title: "Software Engineer",
      company: "XYZ Inc.",
      location: "San Francisco",
      salary: 90000,
    ),
    // Add more job objects here
  ];

  List<Job> filteredJobs = [];

  String? _selectedLocation;
  double _minSalary = 0;
  double _maxSalary = 200000;

  @override
  void initState() {
    super.initState();
    filteredJobs.addAll(jobList);
  }

  void _applyFilters() {
    setState(() {
      filteredJobs = jobList.where((job) {
        final meetsLocation = _selectedLocation == null ||
            job.location.toLowerCase().contains(_selectedLocation!);
        final meetsSalary =
            job.salary >= _minSalary && job.salary <= _maxSalary;
        return meetsLocation && meetsSalary;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Jobs"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Search Jobs",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Enter job title",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (value) {
                      // Implement dynamic search functionality
                    },
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "Filters",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  DropdownButtonFormField<String>(
                    value: _selectedLocation,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedLocation = newValue;
                      });
                    },
                    items: ["New York", "San Francisco"]
                        .map((location) => DropdownMenuItem<String>(
                              value: location,
                              child: Text(location),
                            ))
                        .toList(),
                    decoration: InputDecoration(
                      labelText: "Location",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Salary Range"),
                      Text("\$${_minSalary.toInt()} - \$${_maxSalary.toInt()}"),
                    ],
                  ),
                  RangeSlider(
                    min: 0,
                    max: 200000,
                    divisions: 20,
                    values: RangeValues(_minSalary, _maxSalary),
                    onChanged: (values) {
                      setState(() {
                        _minSalary = values.start;
                        _maxSalary = values.end;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text("Apply Filters"),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final job = filteredJobs[index];
                return ListTile(
                  title: Text(job.title),
                  subtitle: Text("${job.company}, ${job.location}"),
                  trailing: Text("\$${job.salary.toStringAsFixed(2)}"),
                  // Implement onTap to navigate to job details screen
                  onTap: () {
                    // Navigate to job details screen
                  },
                );
              },
              childCount: filteredJobs.length,
            ),
          ),
        ],
      ),
    );
  }
}

class Job {
  final String title;
  final String company;
  final String location;
  final double salary;

  Job({
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
  });
}

void main() {
  runApp(MaterialApp(
    home: SearchJobs(),
  ));
}
