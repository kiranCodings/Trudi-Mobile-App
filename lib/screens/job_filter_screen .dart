import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/filter_provider.dart';
import '../provider/job_provider.dart';
import '../model/filter_model.dart';

class JobFilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<JobFilterScreen> {
  Map<String, List<dynamic>> selectedFilters = {
    'locations': [],
    'skills': [],
    'roles': [],
    'industries': [],
    'educations': [],
  };

  void toggleSelection(String category, dynamic value) {
    setState(() {
      if (selectedFilters[category]!.contains(_getItemId(value))) {
        selectedFilters[category]!.remove(_getItemId(value));
      } else {
        selectedFilters[category]!.add(_getItemId(value));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Provider.of<JobProvider>(context, listen: false).fetchJobsWithFilters(
                locations: selectedFilters['locations'],
                skills: selectedFilters['skills'],
                roles: selectedFilters['roles'],
                industries: selectedFilters['industries'],
                educations: selectedFilters['educations'],
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<FilterProvider>(context, listen: false).fetchFilters(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred!'));
          } else {
            return Consumer<FilterProvider>(
              builder: (ctx, filterProvider, _) {
                final filterData = filterProvider.filterData!;
                return ListView(
                  children: [
                    FilterSection(
                      title: 'Locations',
                      items: filterData.locations,
                      selectedItems: selectedFilters['locations']!,
                      onToggle: (value) => toggleSelection('locations', value),
                    ),
                    FilterSection(
                      title: 'Skills',
                      items: filterData.skills,
                      selectedItems: selectedFilters['skills']!,
                      onToggle: (value) => toggleSelection('skills', value),
                    ),
                    FilterSection(
                      title: 'Roles',
                      items: filterData.roles,
                      selectedItems: selectedFilters['roles']!,
                      onToggle: (role) => toggleSelection('roles', role),
                      isRole: true,
                    ),
                    FilterSection(
                      title: 'Industries',
                      items: filterData.industries,
                      selectedItems: selectedFilters['industries']!,
                      onToggle: (industry) => toggleSelection('industries', industry),
                      isIndustry: true,
                    ),
                    FilterSection(
                      title: 'Educations',
                      items: filterData.educations,
                      selectedItems: selectedFilters['educations']!,
                      onToggle: (education) => toggleSelection('educations', education),
                      isEducation: true,
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  dynamic _getItemId(dynamic item) {
    if (item is String || item is int) {
      return item;
    } else {
      return item.id;
    }
  }
}

class FilterSection extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  final List<dynamic> selectedItems;
  final Function(dynamic) onToggle;
  final bool isRole;
  final bool isIndustry;
  final bool isEducation;

  FilterSection({
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.onToggle,
    this.isRole = false,
    this.isIndustry = false,
    this.isEducation = false,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      children: items.map<Widget>((item) {
        final isSelected = selectedItems.contains(_getItemId(item));
        return CheckboxListTile(
          title: Text(_getItemName(item)),
          value: isSelected,
          onChanged: (bool? value) {
            if (value != null) {
              onToggle(item);
            }
          },
        );
      }).toList(),
    );
  }

  dynamic _getItemId(dynamic item) {
    if (item is String || item is int) {
      return item;
    } else {
      return item.id;
    }
  }

  String _getItemName(dynamic item) {
    if (isRole) {
      return item.roleName;
    } else if (isIndustry) {
      return item.industryType;
    } else if (isEducation) {
      return item.name;
    } else {
      return item.toString();
    }
  }
}
