import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:client/data_models/user.dart';
import 'package:client/util/app_url.dart';
import 'package:client/util/shared_preference.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      AppUrl.login,
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      var userData = responseData['data'];

      User authUser = User.fromJson(userData);

      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'data': authUser};
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['message'],
        'data': null
      };
    }
    return result;
  }

  FutureOr<dynamic> register(String name, String email, String password) async {
    var result;
    var res = await post(AppUrl.register,
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'});

    Map<dynamic, dynamic> responseData = json.decode(res.body);
    var userData = responseData['data'];

    User authUser = User.fromJson(userData);

    UserPreferences().saveUser(authUser);

    if (res.statusCode == 201) {
      result = {'message': responseData['message'], 'data': authUser};
    } else {
      result = {'message': responseData['message'], 'data': null};
    }
    return result;
  }

  bool logout() {
    try {
      UserPreferences().removeUser();
    } catch (err) {
      print(err);
      return false;
    } finally {
      return true;
    }
  }
}
