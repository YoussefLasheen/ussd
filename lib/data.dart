import 'dart:convert';
import 'dart:io';

import 'package:ussd/flavors.dart';
import 'package:ussd/models/banner.dart';
import 'package:ussd/models/code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<AppResponse> fetchData() async {
  final prefs = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );
  try {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/YoussefLasheen/ussd/master/data/v1.json'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      prefs.setString("data", response.body);
      return AppResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  } catch (e) {
    if (prefs.containsKey("data")) {
      return AppResponse.fromJson(jsonDecode(prefs.getString("data")!));
    } else {
      rethrow;
    }
  }
}

class AppResponse {
  final List<BannerModel> banners;
  final List<CodeSection> codeSections;

  AppResponse({required this.codeSections, required this.banners});

  factory AppResponse.fromJson(Map<String, dynamic> json) {
    String id = F.flavor.name;

    final list = json['codes'] as List<dynamic>;

    Map map = list.firstWhere((element) => element['id'] == id);

    List<BannerModel> banners = [];

    final requiredTags = [
      "flavor_${F.flavor.name}",
      "platform_${Platform.operatingSystem}",
    ];
    for (var banner in json['banners']) {
      final bannerModel = BannerModel.fromJson(banner);
      if (requiredTags.every((tag) => bannerModel.tags.contains(tag))) {
        banners.add(bannerModel);
      }
    }

    return AppResponse(
      codeSections: List<CodeSection>.from(
        map['data'].map(
          (x) => CodeSection.fromJson(x as Map<String, dynamic>),
        ),
      ),
      banners: banners,
    );
  }
}
