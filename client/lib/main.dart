import 'package:client/data_models/user.dart';
import 'package:client/screens/login_screen.dart';
import 'package:client/providers/auth_provider.dart';
import 'package:client/providers/user_provider.dart';
import 'package:client/util/check_token.dart';
import 'package:client/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/router.dart';
import 'package:provider/provider.dart';

import 'screens/register_screen.dart';

void main() => runApp(Client());

class Client extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<User> userInfo() async {
      bool token = await checkToken();
      if (token) {
        return UserPreferences().getUser();
      } else {
        throw Error();
      }
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          title: 'Gym App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder(
              future: userInfo(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Login();
                    } else {
                      Provider.of<UserProvider>(context, listen: false).setUser(snapshot.data as User);
                    }
                    return RouterScreen();
                }
              }),
          routes: {
            '/router': (context) => RouterScreen(),
            '/login': (context) => Login(),
            '/register': (context) => Register(),
          }),
    );
  }
}
