// ignore_for_file: deprecated_member_use, prefer_function_declarations_over_variables

import 'package:another_flushbar/flushbar.dart';
import 'package:client/providers/auth_provider.dart';
import 'package:client/util/shared_preference.dart';
import 'package:client/widgets/long_buttons.dart';
import 'package:flutter/material.dart';
import 'package:client/data_models/user.dart';
import 'package:client/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    AuthProvider auth = Provider.of<AuthProvider>(context);

    var logout = () {
      bool res = (auth.logout());
      print(res);
      if (res) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        Flushbar(
          title: "Error logging out",
          message: "Error logging out, try again!",
          duration: const Duration(seconds: 5),
        ).show(context);
      }
    };

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Center(child: Text(user.name!)),
          const SizedBox(height: 100),
          longButtons("Logout", logout)
        ],
      ),
    );
  }
}
