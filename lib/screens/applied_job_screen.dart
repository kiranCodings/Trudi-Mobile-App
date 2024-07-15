import 'package:eclass/widgets/applied_job_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eclass/provider/applied_job_provider.dart';

class AppliedJobSearchScreen extends StatefulWidget {
  @override
  _AppliedJobSearchScreenState createState() => _AppliedJobSearchScreenState();
}

class _AppliedJobSearchScreenState extends State<AppliedJobSearchScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<AppliedJobProvider>(context, listen: false).fetchAppliedJobs();
  }

  void _performSearch(String query) {
    Provider.of<AppliedJobProvider>(context, listen: false)
        .fetchAppliedJobs(query: query);
  }

  @override
  Widget build(BuildContext context) {
    final appliedJobProvider = Provider.of<AppliedJobProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Applied Jobs'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.filter_list),
        //     onPressed: () {
        //       // Implement filter functionality
        //     },
        //   ),
        // ],
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
                onSubmitted: _performSearch, // Call _performSearch when submitted
                decoration: InputDecoration(
                  hintText: 'Search applied jobs',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: appliedJobProvider.appliedJobs.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: appliedJobProvider.appliedJobs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final appliedJob =
                          appliedJobProvider.appliedJobs[index];
                      return AppliedJobListItem(appliedJob: appliedJob);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}