class Personal {
  final int id;
  final int? userId;
  final String jobCategoryId;
  final String fname;
  final String lname;
  final String profession;
  final String workingAt;
  final String country;
  final String? countryName;
  final String state;
  final String? stateName;
  final String city;
  final String? cityName;
  final String? pin;
  final String? dob;
  final String image;
  final String? keyword;
  final String? experience;
  final String? salary;
  final String? shift;
  final String address;
  final String phone;
  final String email;
  final List<dynamic> skill;
  final String? skillLMS;
  final String strength;
  final String interest;
  final String objective;
  final String language;
  final String? englishLavel;
  final String? jobRadius;
  final String status;
  final String verified;
  final String? message;
  final String? gender;
  final String createdAt;
  final String updatedAt;

  Personal({
     required this.id,
    this.userId,
    required this.jobCategoryId,
    required this.fname,
    required this.lname,
    required this.profession,
    required this.workingAt,
    required this.country,
    this.countryName,
    required this.state,
    this.stateName,
    required this.city,
    this.cityName,
    this.pin,
    this.dob,
    required this.image,
    this.keyword,
    this.experience,
    this.salary,
    this.shift,
    required this.address,
    required this.phone,
    required this.email,
    required this.skill,
    this.skillLMS,
    required this.strength,
    required this.interest,
    required this.objective,
    required this.language,
    this.englishLavel,
    this.jobRadius,
    required this.status,
    required this.verified,
    this.message,
    this.gender,
    required this.createdAt,
    required this.updatedAt,
    
  });

  factory Personal.fromJson(Map<String, dynamic> json) {
    return Personal(
      id: json['id'],
      userId: json['user_id'],
      jobCategoryId: json['job_category_id'] ?? '',
      fname: json['fname'] ?? '',
      lname: json['lname'] ?? '',
      profession: json['profession'] ?? '',
      workingAt: json['working_at'] ?? '',
      country: json['country'] ?? '',
      countryName: json['country_name'],
      state: json['state'] ?? '',
      stateName: json['state_name'],
      city: json['city'] ?? '',
      cityName: json['city_name'],
      pin: json['pin'],
      dob: json['dob'],
      image: json['image'] ?? '',
      keyword: json['keyword'],
      experience: json['experience'],
      salary: json['salary'],
      shift: json['shift'],
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      skill: json['skill'] != null
    ? (json['skill'] is List
        ? List<String>.from(json['skill'])
        : [json['skill'].toString()])
    : [],

      skillLMS: json['skill_LMS'],
      strength: json['strength'] ?? '',
      interest: json['interest'] ?? '',
      objective: json['objective'] ?? '',
      language: json['language'] ?? '',
      englishLavel: json['english_lavel'],
      jobRadius: json['job_radius'],
      status: json['status'] ?? '',
      verified: json['verified'] ?? '',
      message: json['message'],
      gender: json['gender'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class Education {
  final int id;
  final int userId;
  final String course;
  final String school;
  final String marks;
  final String yearOfPassing;

  Education({
    required this.id,
    required this.userId,
    required this.course,
    required this.school,
    required this.marks,
    required this.yearOfPassing,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'],
      userId: json['user_id'],
      course: json['course'],
      school: json['school'],
      marks: json['marks'].toString(),
      yearOfPassing: json['yearofpassing'],
    );
  }
}

class Experience {
  final int id;
  final int userId;
  final String jobTitle;
  final String employer;
  final String city;
  final String state;
  final String startDate;
  final String endDate;

  Experience({
    required this.id,
    required this.userId,
    required this.jobTitle,
    required this.employer,
    required this.city,
    required this.state,
    required this.startDate,
    required this.endDate,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'],
      userId: json['user_id'],
      jobTitle: json['jobtitle'],
      employer: json['employer'],
      city: json['city'],
      state: json['state'],
      startDate: json['startdate'],
      endDate: json['enddate'],
    );
  }
}

class Project {
  final int id;
  final int userId;
  final String projectTitle;
  final String role;
  final String description;

  Project({
    required this.id,
    required this.userId,
    required this.projectTitle,
    required this.role,
    required this.description,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      userId: json['user_id'],
      projectTitle: json['projecttitle'],
      role: json['role'],
      description: json['description'],
    );
  }
}

class Resume {
  final Personal personal;
  final List<Education> education;
  final List<Experience> experiences;
  final List<Project> projects;

  Resume({
    required this.personal,
    required this.education,
    required this.experiences,
    required this.projects,
  });

  factory Resume.fromJson(Map<String, dynamic> json) {
    final personalData = json['personal'] as Map<String, dynamic>;
    final List<dynamic> educationData = json['education'] ?? [];
    final List<dynamic> experiencesData = json['works'] ?? [];
    final List<dynamic> projectsData = json['project'] ?? [];

    return Resume(
      personal: Personal.fromJson(personalData),
      education: educationData.map((data) => Education.fromJson(data)).toList(),
      experiences: experiencesData.map((data) => Experience.fromJson(data)).toList(),
      projects: projectsData.map((data) => Project.fromJson(data)).toList(),
    );
  }
}