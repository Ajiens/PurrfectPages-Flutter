import 'package:flutter/material.dart';
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
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Wish List'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
      ],
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
            MaterialPageRoute(builder: (context) => const Profile()));
        break;
      // Tambahkan case sesuai dengan jumlah halaman yang Anda miliki
    }
  }
}

