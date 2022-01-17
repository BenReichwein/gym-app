import 'package:client/util/app_url.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString("token");

  final response = await post(
    AppUrl.getToken,
    body: token,
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Error();
  }
}
