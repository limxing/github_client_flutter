import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:github_client_flutter/common/ProfileChangedNotifier.dart';
import 'package:github_client_flutter/routes/LoginRoute.dart';
import 'package:github_client_flutter/routes/home_route.dart';
import 'package:provider/provider.dart';

import 'common/Global.dart';

void main() => Global.init().then((value) => runApp(const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ThemeModel()),
        ChangeNotifierProvider.value(value: UserModel()),
        ChangeNotifierProvider.value(value: LocaleModel()),
      ],
      child: Consumer2<ThemeModel, LocaleModel>(
          builder: (context, themeModel, localeModel, child) {
        return MaterialApp(
          theme: ThemeData(
            primarySwatch: themeModel.theme,
          ),
          // onGenerateTitle: (context){
          //   return GmLocaization
          // },
          home: HomeRoute(),
          locale: localeModel.getLocal(),
          // supportedLocales: const [
          //    Locale('en','US'),
          //    Locale('zh','CN'),
          // ],
          // localizationsDelegates: [
          //   GlobalMat
          // ],
          routes: {
            "login": (context) => LoginRoute(),
          },
          builder: FlutterSmartDialog.init(),
        );
      }),
    );
  }
}
