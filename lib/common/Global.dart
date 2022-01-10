import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_client_flutter/models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CacheObject.dart';
import 'Git.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red
];

class Global {
  static SharedPreferences? _preferences;

  static Profile profile = Profile();

  static NetCache netCache = NetCache();

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
    var _profile = _preferences?.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }
    profile.cache = profile.cache ?? CacheConfig()
      ..enable = true
      ..maxAge = 3600
      ..maxCount = 100;

    Git.init();
  }
  static saveProfile() => _preferences?.setString("profile", jsonEncode(profile.toJson()));

  static bool get  isRelease => const bool.fromEnvironment("dart.vm.product");
}
