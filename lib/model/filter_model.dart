// models/filter_model.dart

class FilterModel {
  final List<String> locations;
  final List<String> skills;
  final List<Role> roles;
  final List<Industry> industries;
  final List<Education> educations;

  FilterModel({
    required this.locations,
    required this.skills,
    required this.roles,
    required this.industries,
    required this.educations,
  });

  factory FilterModel.fromJson(Map<String, dynamic> json) {
    return FilterModel(
      locations: List<String>.from(json['locations']),
      skills: List<String>.from(json['skills']),
      roles: List<Role>.from(json['roles'].map((role) => Role.fromJson(role))),
      industries: List<Industry>.from(json['industries'].map((industry) => Industry.fromJson(industry))),
      educations: List<Education>.from(json['educations'].map((education) => Education.fromJson(education))),
    );
  }
}

class Role {
  final int id;
  final String roleName;

  Role({required this.id, required this.roleName});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      roleName: json['role_name'],
    );
  }
}

class Industry {
  final int id;
  final String industryType;

  Industry({required this.id, required this.industryType});

  factory Industry.fromJson(Map<String, dynamic> json) {
    return Industry(
      id: json['id'],
      industryType: json['industry_type'],
    );
  }
}

class Education {
  final int id;
  final String name;

  Education({required this.id, required this.name});

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'],
      name: json['name'],
    );
  }
}
