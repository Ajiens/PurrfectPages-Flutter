import 'package:flutter/material.dart';
import 'package:purrfect_pages/screens/navbar.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList>{
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text('WishList User'),
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
    ),
    body: const Align(
      alignment: Alignment.center,
      child: Text("WishList User"),
    ),
    bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        }, backgroundColor: Colors.indigo,
    )
    );
  }
}
