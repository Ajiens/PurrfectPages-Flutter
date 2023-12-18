// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:purrfect_pages/models/wishlist.dart';
import 'package:purrfect_pages/screens/navbar.dart';
import 'package:purrfect_pages/screens/deskripsi_buku.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  int _currentIndex = 1;
  List<Wishlist> myWishlist = [];

  Future<List<Wishlist>> fetchData() async {
    final request = context.watch<CookieRequest>();
    final response = await request.get('https://alwan.pythonanywhere.com/wishlist/get-books/');

    myWishlist.clear();

    for (var d in response) {
      if (d != null) {
        myWishlist.add(Wishlist.fromJson(d));
      }
    }
    return myWishlist;
  }


   Future<void> deleteWishlist(int index) async {
    final request = context.read<CookieRequest>();
    final response = await request.postJson(
      "https://alwan.pythonanywhere.com/wishlist/remove/${myWishlist[index].pk}/",
      jsonEncode({'buku_id': myWishlist[index].pk}),
    ); 
    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Buku berhasil dihapus")),
      );
      setState(() {
        myWishlist.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text("Gagal menghapus buku"),
        ));
    }
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
                  child: wishlistListView(myWishlist),
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
        }, backgroundColor: Colors.indigo,
      ),
      
    );
  }

  Widget wishlistListView(List<Wishlist> myWishlist) {
    return ListView.builder(
      itemCount: myWishlist.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _pergiKeDeskripsiBuku(context, myWishlist[index].pk);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text(
                      "${myWishlist[index].title} dengan ID: ${myWishlist[index].pk}!")));
          },
          child: Card(
            elevation: 5,
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                leading: Container(
                  child: Image.network(
                  myWishlist[index].coverLink,
                  fit: BoxFit.cover,
                  )
                ),
                title: Text(
                  myWishlist[index].title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Author: ${myWishlist[index].author}'),
                    Text('Price: ${myWishlist[index].harga}'),
                    Text('Keterangan: ${myWishlist[index].keterangan}'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await deleteWishlist(index);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _pergiKeDeskripsiBuku(BuildContext context, int idBuku) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeskripsiBuku(idBuku: idBuku),
        ));
    setState(() {
      idBuku = result;
    });
  }
}