import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eclass/provider/job_provider.dart';
import 'package:eclass/widgets/job_list_item.dart'; 
class JobSearchScreen extends StatefulWidget {
  @override
  _JobSearchScreenState createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<JobProvider>(context, listen: false).fetchJobs();
  }

  void _performSearch(String query) {
    Provider.of<JobProvider>(context, listen: false).fetchJobs(query: query);
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Job Search'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              Navigator.of(context).pushNamed("/jobfilter").then((value) {
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted:
                    _performSearch, // Call _performSearch when submitted
                decoration: InputDecoration(
                  hintText: 'Search jobs',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: jobProvider.jobs.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: jobProvider.jobs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final job = jobProvider.jobs[index];
                      return JobListItem(job: job);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
