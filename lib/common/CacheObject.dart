import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:github_client_flutter/common/Global.dart';


/// Author: 李利锋
/// Date：2022-01-10
///
class CacheObject {
  Response response;
  int timeStamp;

  CacheObject(this.response)
      : timeStamp = DateTime.now().millisecondsSinceEpoch;

  @override
  bool operator ==(Object other) {
    return response.hashCode == other.hashCode;
  }

  @override
  int get hashCode => response.realUri.hashCode;
}

class NetCache extends Interceptor {
  var cache = LinkedHashMap<String, CacheObject>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("${options.uri}\n${options.headers}");
    if (Global.profile.cache?.enable == true) {
      //判断是否是下拉刷新，应该是请求的时候增加的参数
      bool refresh = options.extra["refresh"] == true;

      if (refresh) {
        if (options.extra["list"] == true) {
          cache.removeWhere((key, value) => key.contains(options.path));
        } else {
          delete(options.uri.toString());
        }
      }
      if (options.extra["noCache"] == true &&
          options.method.toLowerCase() == "get") {
        String key = options.extra["cacheKey"] ?? options.uri.toString();

        var ob = cache[key];
        if (ob != null) {
          if (DateTime.now().millisecondsSinceEpoch - ob.timeStamp / 1000 <
              Global.profile.cache!.maxAge) {
            //缓存未过期
            handler.resolve(cache[key]!.response);
            return;
          } else {
            delete(key);
          }
        }
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {}

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (Global.profile.cache?.enable == true) {
      _saveCache(response);
    }
    super.onResponse(response, handler);
  }

  void delete(String key) {
    cache.remove(key);
  }

  void _saveCache(Response<dynamic> response) {
    RequestOptions options = response.requestOptions;
    if (options.extra["noCache"] != true &&
        options.method.toLowerCase() == "get") {
      if (cache.length == Global.profile.cache?.maxCount) {
        cache.remove(cache[cache.keys.first]);
      }
      String key = options.extra["cacheKey"] ?? options.uri.toString();
      cache[key] = CacheObject(response);
    }
  }
}
