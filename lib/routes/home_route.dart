import 'package:flukit/flukit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_client_flutter/common/Git.dart';
import 'package:github_client_flutter/common/ProfileChangedNotifier.dart';
import 'package:github_client_flutter/models/index.dart';
import 'package:provider/provider.dart';

import 'RepoItem.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Github"),
      ),
      body: _buildBody(),
      // drawer: MyDrawer(),
    );
  }

  Future<Null> _pullToRefresh() async {
    try{
      var data = await Git(context: context).getRepos(
        refresh: true,
        queryParameters: {"page": 1, "page_size": 20},
      );

      setState(() {
        _list = data;
      });
    }catch(e){
      print(e);
    }

    return null;
  }

  var _list = <Repo>[];

  Widget _buildBody() {

    var userModel = Provider.of<UserModel>(context);
    userModel.addListener(() {
      print("监听到更改");
      _pullToRefresh();
    });
    if (userModel.isLogin) {
      return RefreshIndicator(
        onRefresh: _pullToRefresh,
        child: ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index) {
            return RepoItem(_list[index]);
          },
          physics: const AlwaysScrollableScrollPhysics(),
        ),
      );
    } else {
      return Center(
        child: ElevatedButton(
          child: Text("登录"),
          onPressed: () => Navigator.of(context).pushNamed( "login"),
        ),
      );
    }
  }
}
