import 'dart:convert';

import 'package:flutter/services.dart';

sealed class FileUtils {

  static Future<T> loadJson<T>(String filepath) async {
    String json = await rootBundle.loadString(filepath);
    return jsonDecode(json) as T;
  }

}