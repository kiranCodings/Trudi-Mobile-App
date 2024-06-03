class Job {
  final int id;
  final int userId;
  final String companyName;
  final String jobTitle;
  final String description;
  final String minExperience;
  final String maxExperience;
  final String experience;
  final String years;
  final String location;
  final String requirement;
  final String role;
  final String industryType;
  final List<dynamic> employmentType;
  final String image;
  final String minSalary;
  final String maxSalary;
  final String salary;
  final List<dynamic> skills;
  final String pdf;
  final String message;
  final String varified;
  final String status;
  final String approved;
  final bool isApplied;
  final DateTime createdAt;
  final DateTime updatedAt;

  Job({
    required this.id,
    required this.userId,
    required this.companyName,
    required this.jobTitle,
    required this.description,
    required this.minExperience,
    required this.maxExperience,
    required this.experience,
    required this.years,
    required this.location,
    required this.requirement,
    required this.role,
    required this.industryType,
    required this.employmentType,
    required this.image,
    required this.minSalary,
    required this.maxSalary,
    required this.salary,
    required this.skills,
    required this.pdf,
    required this.message,
    required this.varified,
    required this.status,
    required this.approved,
    required this.isApplied,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      userId: json['user_id'],
      companyName: json['companyname'],
      jobTitle: json['title'],
      description: json['description'],
      minExperience: json['min_experience'],
      maxExperience: json['max_experience'],
      experience: json['experience'],
      years: json['years'],
      location: json['location'],
      requirement: json['requirement'],
      role: json['role'],
      industryType: json['industry_type'],
      employmentType: json['employment_type'] != null
          ? List<String>.from(
              json['employment_type'].map((item) => item.toString()))
          : [],
      image: json['image'],
      minSalary: json['min_salary'],
      maxSalary: json['max_salary'],
      salary: json['salary'],
      skills: json['skills'] != null
          ? List<String>.from(
              json['skills'].map((item) => item.toString()))
          : [],
      pdf: json['pdf'],
      message: json['message'],
      varified: json['varified'],
      status: json['status'],
      approved: json['approved'],
      isApplied: json['isApplied'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
