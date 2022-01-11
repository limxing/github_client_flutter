import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:github_client_flutter/common/Global.dart';
import 'package:github_client_flutter/models/index.dart';

class Git {
  BuildContext context;
  late Options _options;

  Git({required this.context}) {
    _options = Options(extra: {"context": context});
  }

  static Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.github.com/',
      connectTimeout: 5000,
      sendTimeout: 5000,
      headers: {
        HttpHeaders.acceptHeader:
            "application/vnd.github.squirrel-girl-preview,"
                "application/vnd.github.symmetra-preview+json",
      },
    ),
  );

  static void init() {
    dio.interceptors.add(Global.netCache);
    dio.options.headers[HttpHeaders.authorizationHeader] = Global.profile.token;

    //在调试模式下需要抓包
    if (!Global.isRelease) {
      if (dio.httpClientAdapter is DefaultHttpClientAdapter) {
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (client) {
          client.findProxy = (uri) {
            return "PROXY 192.168.1.102:8888";
          };
          client.badCertificateCallback = (cert, host, port) => true;
        };
      }
    }
  }

  //登录
  Future<User> login(String login, String pwd) async {
    String basic = 'Basic ' + base64.encode(utf8.encode("$login:$pwd"));

    var result = await dio.get("/users/$login",
        options: _options.copyWith(headers: {
          HttpHeaders.authorizationHeader: basic
        }, extra: {
          "noCache": true,
        }));

    dio.options.headers[HttpHeaders.authorizationHeader] = basic;
    Global.netCache.cache.clear();
    Global.profile.token = basic;
    print(result.data);
    return User.fromJson(result.data);
  }

  Future<List<Repo>> getRepos(
      {Map<String, dynamic>? queryParameters, refresh = true}) async {
    if (refresh) {
      _options.extra?.addAll({"refresh": true, "list": true});
    }
    var result = await dio.get("user/repos",
        queryParameters: queryParameters, options: _options);
    print(result.data);
    return result.data.map((e) => Repo.fromJson(e)).toList();
  }
}
