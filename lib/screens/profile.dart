import 'package:flutter/material.dart';
import 'package:purrfect_pages/screens/navbar.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text('Profile User'),
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
    ),
    body: const Align(
      alignment: Alignment.center,
      child: Text("Profile user"),
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
