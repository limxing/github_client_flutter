import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

Widget gmAvatar(String url,
    {double width = 30,
      double? height,
      BoxFit? fit,
      BorderRadius? borderRadius}) {
  var placeHolder = Image.asset(
    "images/flutter.png", width: width, height: height,);
  return ClipRRect(
    borderRadius: borderRadius ?? BorderRadius.circular(2),
    child: CachedNetworkImage(imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeHolder,
      errorWidget: (_, _url, error) => placeHolder,),
  );
}
