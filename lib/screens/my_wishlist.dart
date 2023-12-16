// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:purrfect_pages/models/wishlist.dart';
import 'package:purrfect_pages/screens/navbar.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  int _currentIndex = 1;
  
  Future<List<Wishlist>> fetchData() async {
    final request = context.watch<CookieRequest>();
    final response = await request.get('http://127.0.0.1:8000/wishlist/get-books/');

    List<Wishlist> myWishlist = [];

    for (var d in response) {
      if (d != null) {
        myWishlist.add(Wishlist.fromJson(d));
      }
    }
    return myWishlist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Wishlist')),
      body: FutureBuilder<List<Wishlist>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No data available'),
            );
          } else {
            List<Wishlist> myWishlist = snapshot.data!;

            return Column(
              children: <Widget>[
                Expanded(
                  child: tableBody(
                    context,
                    myWishlist,
                  ),
                ),
              ],
            );
          }
        },
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

  SingleChildScrollView tableBody(BuildContext ctx, List<Wishlist> myWishlist) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text(
                "Title",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              numeric: false,
            ),
            DataColumn(
              label: Text(
                "Author",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              numeric: false,
            ),
            DataColumn(
              label: Text(
                "Price",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              numeric: true,
            ),
            DataColumn(
              label: Text(
                "Keterangan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              numeric: false,
            ),
          ],
          rows: myWishlist.map(
            (myWishlist) => DataRow(
              cells: [
                DataCell(Text(myWishlist.title)),
                DataCell(Text(myWishlist.author)),
                DataCell(Text('${myWishlist.harga}')),
                DataCell(Text(myWishlist.keterangan)),
              ],
            ),
          ).toList(),
        ),
      ),
      
    );
  }
}
