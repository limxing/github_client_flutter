import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:github_client_flutter/common/Git.dart';
import 'package:github_client_flutter/common/Global.dart';
import 'package:github_client_flutter/common/ProfileChangedNotifier.dart';
import 'package:github_client_flutter/common/my_icons.dart';
import 'package:github_client_flutter/models/user.dart';
import 'package:provider/provider.dart';

class LoginRoute extends StatelessWidget {
  const LoginRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
        leading: IconButton(icon: Icon(BeeIcons.delete),onPressed: (){
          Navigator.pop(context);
        },),
      ),
      body: LoginBody(),
    );
  }
}

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  var _usernameController = TextEditingController();
  var _pwdController = TextEditingController();
  var _nameAutoFocuse = true;
  var pwdShow = false;
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _usernameController.text = Global.profile.lastLogin ?? "";
    if (_usernameController.text.isNotEmpty) _nameAutoFocuse = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        16,
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autofocus: _nameAutoFocuse,
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "用户名",
                hintText: "请输入用户名",
                prefixIcon: Icon(Icons.person),
              ),
              validator: (v) {
                return v
                    ?.trim()
                    .isNotEmpty == true ? null : "请输入用户名";
              },
            ),
            TextFormField(
              controller: _pwdController,
              autofocus: !_nameAutoFocuse,
              decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "请输入密码",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon:
                    Icon(pwdShow ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        pwdShow = !pwdShow;
                      });
                    },
                  )),
              obscureText: !pwdShow,
              validator: (v) {
                return v
                    ?.trim()
                    .isNotEmpty == true ? null : "密码错误";
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 25,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(
                  height: 55,
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  onPressed: _onLogin,
                  child: Text(
                    "登录",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onLogin() async {
    print((_formKey.currentState as FormState).validate());
    if ((_formKey.currentState as FormState).validate()) {
      SmartDialog.showLoading();
      try {
        User user = await Git(context: context).login(
            _usernameController.text, _pwdController.text);
        print(user.toJson());
        Provider
            .of<UserModel>(context, listen: false)
            .user = user;
        Navigator.pop(context);
      } catch (e) {
        print(e);
        if (e is Response && e.statusCode == 401){
          SmartDialog.showToast("用户名或密码错误");
        }else{
          SmartDialog.showToast(e.toString());
        }
      } finally {
        SmartDialog.dismiss();
      }
    }
  }
}
