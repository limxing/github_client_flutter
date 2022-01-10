import 'package:flutter/cupertino.dart';
import 'package:github_client_flutter/models/index.dart';

import 'Global.dart';

class ProfileChangedNotifier extends ChangeNotifier {
  Profile get _profile => Global.profile;

  @override
  void notifyListeners() {
    Global.saveProfile();
    super.notifyListeners();
  }
}

class UserModel extends ProfileChangedNotifier {
  User? get _user => _profile.user;

  bool get isLogin => _user != null;

  set user(User? user) {
    if (user?.login != _user?.login) {
      _profile.lastLogin = _user?.login;
      _profile.user = user;
      notifyListeners();
    }
  }
}

class ThemeModel extends ProfileChangedNotifier {
  Locale? getLocal() {
    if (_profile.locale == null) return null;
    var t = _profile.locale!.split("_");
    return Locale(t[0], t[1]);
  }

  String? get _locale => _profile.locale;

  set locale(String locale) {
    if (locale != _locale) {
      _profile.locale = locale;
      notifyListeners();
    }
  }
}
