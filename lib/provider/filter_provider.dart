// providers/filter_provider.dart

import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/filter_model.dart';

class FilterProvider with ChangeNotifier {
  FilterModel? _filterData;

  FilterModel? get filterData => _filterData;

  Future<void> fetchFilters() async {
     Uri uri = Uri.parse("${APIData.getFilter}${APIData.secretKey}");
    http.Response response = await http.get(
      uri,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      _filterData = FilterModel.fromJson(jsonData);
      notifyListeners();
    } else {
      throw Exception('Failed to load filters');
    }
  }
}
