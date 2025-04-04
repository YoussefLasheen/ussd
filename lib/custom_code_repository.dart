import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ussd/models/code.dart';

class CustomCodeRepository {
  static const String _customCodesKey = 'custom_codes';

  // Get custom code section
  Future<List<Code>> getCustomCodeSection() async {
    final prefs = await SharedPreferences.getInstance();
    final codesJson = prefs.getString(_customCodesKey);

    if (codesJson == null || codesJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> codesList = jsonDecode(codesJson);
      final codes = codesList.map((code) => Code.fromJson(code)).toList();
      return codes;
    } catch (e) {
      prefs.remove(_customCodesKey);
      // In case of corrupted data, return an empty list
      return [];
    }
  }

  Future<void> saveCustomCodeSection(List<Code> codes) async {
    final prefs = await SharedPreferences.getInstance();
    final updatedJson = jsonEncode(codes.map((code) => code.toJson()).toList());
    await prefs.setString(_customCodesKey, updatedJson);
  }

  Future<List<Code>> addCustomCode(Code code) async {
    var currentCodes = await getCustomCodeSection();
    currentCodes.add(code);
    await saveCustomCodeSection(currentCodes);
    return currentCodes;
  }

  Future<List<Code>> deleteCustomCode(String id) async {
    var currentCodes = await getCustomCodeSection();
    currentCodes.removeWhere((code) => code.id == id);
    await saveCustomCodeSection(currentCodes);
    return currentCodes;
  }
}
