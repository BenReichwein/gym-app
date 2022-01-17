import 'package:client/data_models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? name = user.name ?? "";
    String? email = user.email ?? "";
    String? phone = user.phone ?? "";
    String? type = user.type ?? "";
    String? token = user.token ?? "";

    prefs.setString("name", name);
    prefs.setString("email", email);
    prefs.setString("phone", phone);
    prefs.setString("type", type);
    prefs.setString("token", token);

    return prefs.commit();
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String name = prefs.getString("name") as String;
    String email = prefs.getString("email") as String;
    String phone = prefs.getString("phone") as String;
    String type = prefs.getString("type") as String;
    String token = prefs.getString("token") as String;

    return User(
      name: name,
      email: email,
      phone: phone,
      type: type,
      token: token,
    );
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("name");
    prefs.remove("email");
    prefs.remove("phone");
    prefs.remove("type");
    prefs.remove("token");
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    return token;
  }
}
