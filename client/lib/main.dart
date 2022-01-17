import 'package:client/screens/login_screen.dart';
import 'package:client/providers/auth_provider.dart';
import 'package:client/providers/user_provider.dart';
import 'package:client/util/check_token.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/router.dart';
import 'package:provider/provider.dart';

import 'screens/register_screen.dart';

void main() => runApp(Client());

class Client extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

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
              future: checkToken(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Login();
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
