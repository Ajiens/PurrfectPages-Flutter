import 'package:flutter/material.dart';
import 'package:purrfect_pages/main/login.dart';
import 'package:purrfect_pages/screens/addbook.dart';
import 'package:purrfect_pages/screens/menu.dart';
import 'package:purrfect_pages/screens/profile.dart';
import 'package:purrfect_pages/screens/wishlist.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Function(int) onTabSelected;
  final int currentIndex;

  const CustomBottomNavigationBar({
    Key? key,
    required this.onTabSelected,
    required this.currentIndex, 
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(

      currentIndex: widget.currentIndex,
      onTap: (index) {
        widget.onTabSelected(index);
        _navigateToPage(context, index); // Fungsi untuk berpindah halaman
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.indigo), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border, color: Colors.indigo), label: 'Wish List'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined, color: Color.fromARGB(255, 31, 46, 57)), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.add, color: Colors.indigo), label: 'Add Book'), // Change icon to 'add'
      ],
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WishList()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Profile(username:  LoginPage.uname,))); //TODO ini apa???
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AddBookPage()));
        break;
      // Tambahkan case sesuai dengan jumlah halaman yang Anda miliki
    }
  }
}

