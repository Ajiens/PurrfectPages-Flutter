import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:purrfect_pages/models/review.dart';

class ReviewBuku extends StatefulWidget{
  final int idBuku;

  ReviewBuku({Key? key, required this.idBuku}) : super(key: key);

  @override
  _ReviewBukuState createState() => _ReviewBukuState();
}

class _ReviewBukuState extends State<ReviewBuku> {
    late Review review;

    @override
    void initState() {
      super.initState();
      fetchData();
    }

    
    // path('deskripsi/<int:id>/review/', review_buku, name="rating_buku"),

    Future<Review> fetchData() async {
    var url = Uri.parse('http://localhost:8000/deskripsi_buku/get_review/');
    var response = await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      // Jika respons status code 200 OK
      dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));

      // Periksa apakah responseData adalah List dan ambil elemen pertama
      Map<String, dynamic> jsonData = responseData[0];

      review = Review.fromJson(jsonData);
      return review;
    } else {
      // Jika respons status code tidak 200 OK
      throw Exception('Failed to load book details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Review Buku')),
      body: FutureBuilder<Review>(
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
            review = snapshot.data!;

            // Gunakan buku untuk menampilkan informasi buku
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Komentar: ${review.komentar}'),
                  Text('Rating User: ${review.ratingUser}'),
                  Text('Date Added: ${review.dateAdded}'),
                ]
              )
            );
          }
        }
      )
    );
  }
}