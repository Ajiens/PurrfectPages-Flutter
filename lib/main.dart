import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:purrfect_pages/main/login.dart';
import 'package:purrfect_pages/screens/landing_page.dart';
import 'package:purrfect_pages/screens/menu.dart';
import 'package:purrfect_pages/screens/profile.dart';
import 'package:purrfect_pages/screens/wishlist.dart';
import 'package:purrfect_pages/screens/addbook.dart'; //Ini buat akses MyHomePage()

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// void main() {
//   runApp(
//     MaterialApp(
//       initialRoute: '/home', // Rute halaman awal
//       routes: {
//         '/home': (context) => MyHomePage(),
//         '/wishlist': (context) => const WishList(),
//         '/profile': (context) => const Profile(),
//         '/addbook':(context) => const AddBookPage(),
//         // Tambahkan rute sesuai dengan jumlah halaman yang Anda miliki
//       },
//     ),
//   );
// }

void main() => runApp(const MyApp());


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CookieRequest request = CookieRequest();
    return Provider(
      create: (_) {
        return request;
      },
    child: MaterialApp(
      title: 'Purrfect Pages',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: LandingPage(),
    )
    );

  }
}


