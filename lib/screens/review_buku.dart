import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:purrfect_pages/models/review.dart';
import 'dart:convert';

class ReviewBuku extends StatefulWidget{
  final int idBuku;

  ReviewBuku({Key? key, required this.idBuku}) : super(key: key);

  @override
  _ReviewBukuState createState() => _ReviewBukuState();
}

class _ReviewBukuState extends State<ReviewBuku> {
   @override
    void initState() {
      super.initState();
      fetchData();
    }

    
    // path('deskripsi/<int:id>/review/', review_buku, name="rating_buku"),

    Future<List<Review>> fetchData() async {
    var url = Uri.parse('http://127.0.0.1:8000/deskripsi_buku/get_review/');
    var response = await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      // Jika respons status code 200 OK
      dynamic responseData = jsonDecode(utf8.decode(response.bodyBytes));

      List<Review> list_review = [];

      for (var data in responseData){
        if (data != null){
          Review kriteria = Review.fromJson(data);
          //Filtering data
          if (kriteria.bookId == widget.idBuku){
            list_review.add(kriteria);
          }
        }
      }
      return list_review;
    } else {
      // Jika respons status code tidak 200 OK
      throw Exception('Failed to load book details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Review Buku')),
      body: FutureBuilder<List<Review>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if(snapshot.data!.length == 0){
            return Center(
              child: Text('Belum ada ulasan pembaca'),
            );
          }else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index){
                Review review = snapshot.data![index];
                return Card(
                  elevation: 4, // Sesuaikan kebutuhan dengan elevasi yang diinginkan
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('User ID-${review.bookId}'),
                    subtitle: Text(review.komentar),
                  ),
                );
              },
            );
          }
        }
      )
    );
  }
}