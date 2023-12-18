import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
import 'package:purrfect_pages/screens/menu.dart';
import 'package:purrfect_pages/screens/profile.dart';
import 'package:purrfect_pages/screens/wishlist.dart';
<<<<<<< HEAD
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

=======
import 'package:purrfect_pages/main/login.dart';
=======
import 'package:purrfect_pages/screens/login.dart';//Ini buat akses MyHomePage()
>>>>>>> 4177c08897160cc64eb9a35085b8a2a0f78e4987

void main() {
  runApp(const MyApp());
}
>>>>>>> 707aae5e8a52c1c2035cf6dd6eb736cebace4fc2

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
<<<<<<< HEAD
    CookieRequest request = CookieRequest();
    return Provider(
      create: (_) {
        return request;
      },
    child: MaterialApp(
      title: 'Purrfect Pages',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    )
=======
=======
>>>>>>> 4177c08897160cc64eb9a35085b8a2a0f78e4987
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
<<<<<<< HEAD
        title: 'Purrfect Pages',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
          useMaterial3: true,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/home': (context) => MyHomePage(),
          '/profile': (context) => Profile(username: LoginPage.uname),
          '/wishlist': (context) => const WishList(),
        },
      ),
>>>>>>> 707aae5e8a52c1c2035cf6dd6eb736cebace4fc2
=======
          title: 'Flutter App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
            useMaterial3: true,
          ),
          home: LoginPage()),
>>>>>>> 4177c08897160cc64eb9a35085b8a2a0f78e4987
    );

  }
}
<<<<<<< HEAD


=======
>>>>>>> 707aae5e8a52c1c2035cf6dd6eb736cebace4fc2
