import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:purrfect_pages/main/login.dart';
import 'dart:convert';
import 'package:purrfect_pages/models/book.dart';
import 'package:purrfect_pages/screens/deskripsi_buku.dart';
import 'package:purrfect_pages/screens/deskripsi_buku_landing_page.dart';
import 'package:purrfect_pages/screens/navbar.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  _BookPageLanding createState() => _BookPageLanding();
}

class _BookPageLanding extends State<LandingPage> {

  Future<List<Book>> fetchProduct() async {
    var url = Uri.parse('https://alwan.pythonanywhere.com/api/books/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Book> list_product = [];
    for (var d in data) {
      if (d != null) {
        list_product.add(Book.fromJson(d));
      }
    }
    return list_product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Katalog Buku'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    
      body: FutureBuilder<List<Book>>(
        future: fetchProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.6,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Book book = snapshot.data![index];
                return BookCard(
                  title: book.fields.title,
                  author: book.fields.author,
                  imageUrl: book.fields.coverLink,
                  rating: book.fields.averageRating,
                  id: book.pk,
                );
              },
            );
          } else {
            return Center(child: Text('No books found'));
          }
        },
      ),
    );
  }

  void _pergiKeDeskripsiBuku(BuildContext context, int idBuku) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeskripsiBukuLandingPage(idBuku: idBuku),
      ),
    );

    setState(() {
      idBuku = result;
    });
  }
}

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;
  final double rating;
  final int id;

  BookCard({
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.rating,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  author,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeskripsiBukuLandingPage(idBuku: id),
                      ),
                    );
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text("${title} dengan ID: ${id}!"),
                      ));
                  },
                  child: Text('Lihat Deskripsi'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo,
                    onPrimary: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
