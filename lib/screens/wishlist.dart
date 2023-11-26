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
    ),
    body: const Align(
      alignment: Alignment.center,
      child: Text("WishList user"),
    ),
    bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
    )
    );
  }
}
