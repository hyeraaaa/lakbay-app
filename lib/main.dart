import 'package:flutter/material.dart';
import 'package:lakbay_app_1/pages/hero.dart';
import 'package:lakbay_app_1/pages/dashboard/user/user.dart';
import 'package:lakbay_app_1/models/account.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: HeroPage(),
      routes: {
        '/dashboard': (context) {
          final user = ModalRoute.of(context)?.settings.arguments as Account?;
          return UserDashboardPage(user: user);
        },
      },
    );
  }
}
