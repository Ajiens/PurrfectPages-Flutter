import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:purrfect_pages/models/book.dart';
import 'package:purrfect_pages/screens/deskripsi_buku.dart';
import 'package:purrfect_pages/screens/navbar.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  
  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<MyHomePage>{
  int _currentIndex = 0;

  Future<List<Book>> fetchProduct() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'http://localhost:8000/api/books/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
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
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            // Tampilkan daftar buku dalam ListView
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Book book = snapshot.data![index];
                return Card(
                  elevation: 4, // Sesuaikan kebutuhan dengan elevasi yang diinginkan
                  margin: EdgeInsets.all(8), // Sesuaikan kebutuhan dengan margin yang diinginkan
                  child: GestureDetector(
                    onTap: () { //TODO Tambahkan async -> Masuk ke Halaman Review
                      // Tangani aksi ketika buku dipencet
                      _pergiKeDeskripsiBuku(context, book.pk);
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                            content: Text("${book.fields.title} dengan ID: ${book.pk}!")));
                      
                    },
                    child: ListTile(
                      title: Text(book.fields.title),
                      subtitle: Text(book.fields.author),
                      leading: Image.network(
                        book.fields.coverLink,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      
                      // ... tambahkan widget lain sesuai kebutuhan untuk menampilkan informasi buku
                    ),
                  ));
              },
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

