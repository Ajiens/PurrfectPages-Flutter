import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
//import 'package:purrfect_pages/screens/menu.dart';
//import 'package:purrfect_pages/screens/profile.dart';
//import 'package:purrfect_pages/screens/wishlist.dart'; //Ini buat akses MyHomePage()
import 'package:purrfect_pages/main/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
          title: 'Purrfect Pages',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
            useMaterial3: true,
          ),
          home: const LoginPage()),
    );
  }
}