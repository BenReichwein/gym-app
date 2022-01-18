// ignore_for_file: prefer_function_declarations_over_variables, await_only_futures

import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:client/data_models/user.dart';
import 'package:client/providers/auth_provider.dart';
import 'package:client/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:client/widgets/input_decoration.dart';
import 'package:client/widgets/long_buttons.dart';
import 'package:client/util/validators.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  late String _name, _email, _password, _confirmPassword;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final nameField = TextFormField(
      autofocus: false,
      validator: (value) => value!.isEmpty ? "Your name is required" : null,
      onSaved: (value) => _name = value!,
      decoration: buildInputDecoration("Name", Icons.perm_identity_sharp),
    );

    final emailField = TextFormField(
      autofocus: false,
      validator: validateEmail,
      onSaved: (value) => _email = value!,
      decoration: buildInputDecoration("Email", Icons.email),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) => value!.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _password = value!,
      decoration: buildInputDecoration("Password", Icons.lock),
    );

    final confirmPassword = TextFormField(
      autofocus: false,
      validator: (value) => value!.isEmpty ? "Your password is required" : null,
      onSaved: (value) => _confirmPassword = value!,
      obscureText: true,
      decoration: buildInputDecoration("Confirm password", Icons.lock),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        CircularProgressIndicator(),
        Text(" Registering ... Please wait")
      ],
    );

    var doRegister = () async {
      final form = formKey.currentState;
      print(formKey.currentState.toString());
      if (form!.validate()) {
        form.save();
        Map responseData = await (auth.register(_name, _email, _password));
        print(responseData);
        if (responseData['data'] != null) {
          User? user = responseData['data'];
          Provider.of<UserProvider>(context, listen: false).setUser(user!);
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          Flushbar(
            title: "Registration Failed",
            message: responseData['message'],
            duration: const Duration(seconds: 10),
          ).show(context);
        }
      } else {
        Flushbar(
          title: "Invalid form",
          message: "Please Complete the form properly",
          duration: const Duration(seconds: 10),
        ).show(context);
      }
    };

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15.0),
                const Text("Name"),
                const SizedBox(height: 5.0),
                nameField,
                const SizedBox(height: 15.0),
                const Text("Email"),
                const SizedBox(height: 5.0),
                emailField,
                const SizedBox(height: 15.0),
                const Text("Password"),
                const SizedBox(height: 10.0),
                passwordField,
                const SizedBox(height: 15.0),
                const Text("Confirm Password"),
                const SizedBox(height: 10.0),
                confirmPassword,
                const SizedBox(height: 20.0),
                auth.loggedInStatus == Status.Authenticating
                    ? loading
                    : longButtons("Register", doRegister),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
