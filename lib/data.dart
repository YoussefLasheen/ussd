import 'dart:convert';

import 'package:ussd/flavors.dart';
import 'package:ussd/models/code.dart';
import 'package:http/http.dart' as http;

Future<AppResponse> fetchData() async {
  final response = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/YoussefLasheen/ussd/master/data.json'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return AppResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class AppResponse {
  final List<CodeSection> codeSections;

  AppResponse({required this.codeSections});

  factory AppResponse.fromJson(Map<String, dynamic> json) {
    String id = F.flavor.name;

    final list = json['codes'] as List<dynamic>;

    Map map = list.firstWhere((element) => element['id'] == id);

    return AppResponse(
      codeSections: List<CodeSection>.from(
        map['data'].map(
          (x) => CodeSection.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
