import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:purrfect_pages/models/book.dart';

class DeskripsiBuku extends StatefulWidget {
  final int idBuku;

  DeskripsiBuku({Key? key, required this.idBuku}) : super(key: key);

  @override
  _DeskripsiBukuState createState() => _DeskripsiBukuState();
}

class _DeskripsiBukuState extends State<DeskripsiBuku> {
  late Book buku;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<Book> fetchData() async {
  var url = Uri.parse('http://localhost:8000/api/books/${widget.idBuku}/');
  var response = await http.get(url, headers: {"Content-Type": "application/json"});

  if (response.statusCode == 200) {
    // Jika respons status code 200 OK
    dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));

    // Periksa apakah responseData adalah List dan ambil elemen pertama
    Map<String, dynamic> jsonData = responseData[0];

    buku = Book.fromJson(jsonData);
    return buku;
  } else {
    // Jika respons status code tidak 200 OK
    throw Exception('Failed to load book details');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Deskripsi Buku')),
      body: FutureBuilder<Book>(
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
          } else {
            buku = snapshot.data!;

            // Gunakan buku untuk menampilkan informasi buku
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    buku.fields.coverLink,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  Text('Judul: ${buku.fields.title}'),
                  Text('Penulis: ${buku.fields.author}'),
                  // Tambahkan informasi buku lainnya sesuai kebutuhan
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
