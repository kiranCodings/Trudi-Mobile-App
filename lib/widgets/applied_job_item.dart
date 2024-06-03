import 'package:eclass/model/applied_job_model.dart';
import 'package:flutter/material.dart';
import 'package:eclass/screens/applied_job_details_screen.dart';

class AppliedJobListItem extends StatelessWidget {
  final AppliedJob appliedJob;

  AppliedJobListItem({required this.appliedJob});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final createdAt = appliedJob.createdAt;
    final difference = now.difference(createdAt);
    final differenceInDays = difference.inDays;
    final differenceInMonths = (differenceInDays / 30).floor();
    final differenceInYears = (differenceInDays / 365).floor();

    String timeApplied;
    if (differenceInYears > 0) {
      timeApplied =
          '$differenceInYears year${differenceInYears > 1 ? 's' : ''} ago';
    } else if (differenceInMonths > 0) {
      timeApplied =
          '$differenceInMonths month${differenceInMonths > 1 ? 's' : ''} ago';
    } else {
      timeApplied =
          '$differenceInDays day${differenceInDays > 1 ? 's' : ''} ago';
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AppliedJobDetailsScreen(appliedJob: appliedJob),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                appliedJob.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appliedJob.jobTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    appliedJob.companyName,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.green),
                      SizedBox(width: 3),
                      Text(
                        appliedJob.location,
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        timeApplied,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
