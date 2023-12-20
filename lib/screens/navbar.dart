import 'package:flutter/material.dart';
import 'package:purrfect_pages/main/login.dart';
import 'package:purrfect_pages/screens/addbook.dart';
import 'package:purrfect_pages/screens/menu.dart';
import 'package:purrfect_pages/screens/profile.dart';
import 'package:purrfect_pages/screens/borrow.dart';
import 'package:purrfect_pages/screens/my_wishlist.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Function(int) onTabSelected;
  final int currentIndex;

  const CustomBottomNavigationBar({
    Key? key,
    required this.onTabSelected,
    required this.currentIndex,
    required MaterialColor backgroundColor,
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
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Wish List'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'My Book'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add New Book'), // Change icon to 'add'
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
      ],
      selectedItemColor: const Color.fromARGB(255, 56, 78, 202), // Change the color of the selected item here
      unselectedItemColor: Colors.grey, // Change the color of the unselected item here

    );
  }

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MyHomePage()));
        break;
      case 1:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const WishList()));
        break;
      case 2:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Pinjam_Buku()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AddBookPage()));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Profile(username:  LoginPage.uname,))); //TODO ini apa???
        break;
      // Tambahkan case sesuai dengan jumlah halaman yang Anda miliki
    }
  }
}