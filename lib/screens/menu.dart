import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:purrfect_pages/models/book.dart';
import 'package:purrfect_pages/screens/deskripsi_buku.dart';
import 'package:purrfect_pages/screens/navbar.dart';
//nanti abis login bakal di direct kesini

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<MyHomePage> {
  int _currentIndex = 0;

  Future<List<Book>> fetchProduct() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'http://127.0.0.1:8000/api/books/');
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
              padding: EdgeInsets.all(16), // Increased padding around the GridView
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16, // Increased spacing between items
                mainAxisSpacing: 16, // Increased row spacing
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
                );
              },
            );
          } else {
            return Center(child: Text('No books found'));
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
      ),
    );
  }
  void _pergiKeDeskripsiBuku(BuildContext context, int idBuku) async {

    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeskripsiBuku(idBuku: idBuku),
        ));

    // after the SecondScreen result comes back update the Text widget with it
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

  BookCard({
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    // Slightly modify the BookCard for a better fit in a grid
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias, // Added for better styling
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch items
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
                  maxLines: 1, // Ensure the title does not wrap
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
                    Text(rating.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Implement click functionality
                  },
                  child: Text('Lihat Deskripsi'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo, // Button color
                    onPrimary: Colors.white, // Text color
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
