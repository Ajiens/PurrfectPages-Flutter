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
   @override
    void initState() {
      super.initState();
      fetchData();
    }

    
    // path('deskripsi/<int:id>/review/', review_buku, name="rating_buku"),

    Future<List<Review>> fetchData() async {
    var url = Uri.parse('https://alwan.pythonanywhere.com/deskripsi_buku/get_review/');
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
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("User ID-${review.userId}",
                        style: const TextStyle(fontWeight: FontWeight.w400)
                        ),
                        RatingStars(review.ratingUser),
                        DescriptionTextWidget(text: review.komentar)
                      ]
                    ),
                  )
                );
              },
            );
          }
        }
      )
    );
  }
}

class RatingStars extends StatelessWidget {
  final int rating;

  RatingStars(this.rating);

  @override
  Widget build(BuildContext context) {
    List<Icon> stars = List.generate(
      5,
      (index) => Icon(
        index < rating ? Icons.star_rate_rounded : Icons.star_border_rounded,
        color: index < rating ? Colors.amber : Colors.grey,
        size: 20,
      ),
    );

    return Row(
      children: stars,
    );
  }
}

class DescriptionTextWidget extends StatefulWidget {
  final String text;

  DescriptionTextWidget({required this.text});

  @override
  _DescriptionTextWidgetState createState() => new _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 50) {
      firstHalf = widget.text.substring(0, 50);
      secondHalf = widget.text.substring(50, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: secondHalf.isEmpty
          ? new Text(firstHalf)
          : new Column(
              children: <Widget>[
                new Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf)),
                new InkWell(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text(
                        flag ? "show more" : "show less",
                        style: new TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}