import 'package:flutter/material.dart';
import 'package:eclass/model/job.dart';
import 'package:eclass/screens/job_details_screen.dart';

class JobListItem extends StatelessWidget {
  final Job job;

  JobListItem({required this.job});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
final createdAt = job.createdAt;
final difference = now.difference(createdAt);
final differenceInDays = difference.inDays;
final differenceInMonths = (differenceInDays / 30).floor();
final differenceInYears = (differenceInDays / 365).floor();

String timeSincePosted;
if (differenceInYears > 0) {
  timeSincePosted =
      '$differenceInYears year${differenceInYears > 1 ? 's' : ''} ago';
} else if (differenceInMonths > 0) {
  timeSincePosted =
      '$differenceInMonths month${differenceInMonths > 1 ? 's' : ''} ago';
} else if (differenceInDays > 0) {
  timeSincePosted =
      '$differenceInDays day${differenceInDays > 1 ? 's' : ''} ago';
} else {
  final differenceInHours = difference.inHours;
  final differenceInMinutes = difference.inMinutes % 60;
  if (differenceInHours > 0) {
    timeSincePosted =
        '$differenceInHours hour${differenceInHours > 1 ? 's' : ''} ago';
  } else if (differenceInMinutes > 0) {
    timeSincePosted =
        '$differenceInMinutes minute${differenceInMinutes > 1 ? 's' : ''} ago';
  } else {
    timeSincePosted = 'Just now';
  }
}


    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailsScreen(job: job),
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
      job.image,
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Container(
          width: 60,
          height: 60,
          color: Colors.grey[300],
        );
      },
    ),
  ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          job.jobTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (job
                          .isApplied) // New condition to display applied status
                        Icon(Icons.check_circle, color: Colors.green),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    job.companyName,
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
  job.location.length > 10 ? '${job.location.substring(0, 10)}...' : job.location,                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        timeSincePosted,
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
