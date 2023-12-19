import 'dart:async';


import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:purrfect_pages/main/login.dart';
import 'dart:convert';

import 'package:purrfect_pages/models/book.dart';
import 'package:purrfect_pages/models/review.dart';
import 'package:purrfect_pages/screens/review_buku.dart';

import 'package:percent_indicator/percent_indicator.dart';

class DeskripsiBukuLandingPage extends StatefulWidget {
  final int idBuku;

  DeskripsiBukuLandingPage({Key? key, required this.idBuku}) : super(key: key);

  @override
  _DeskripsiBukuLandingPageState createState() => _DeskripsiBukuLandingPageState();
}

class _DeskripsiBukuLandingPageState extends State<DeskripsiBukuLandingPage> {
  late Book buku;

  @override
  void initState() {
    super.initState();
    fetchDataBuku();
    fetchDataReview();
  }

  Future<Book> fetchDataBuku() async {

    var url = Uri.parse('https://alwan.pythonanywhere.com/api/books/${widget.idBuku}/');
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

  Future<List<Review>> fetchDataReview() async {
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
      appBar: AppBar(
        title: Text('Deskripsi Buku'), 
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        ),
      body: FutureBuilder<Book>(
        future: fetchDataBuku(),
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
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      // color: Color.fromRGBO(0, 255, 13, 0.658),
                      child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          '${buku.fields.coverLink}',
                          width: 102,
                          height: 123,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Flexible(
                      child: Container(
                          // color: Color.fromRGBO(0, 68, 255, 0.655),
                          padding: EdgeInsetsDirectional.fromSTEB(9, 9, 9, 9),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(buku.fields.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )),
                                  Text(buku.fields.author),
                                  Text('ISBN: ${buku.fields.isbn}  •  ${buku.fields.numberOfPages} halaman'),
                                  Text('${buku.fields.datePublished}')
                                ],
                              ),
                              Text("Rp.${buku.fields.harga}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  )),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(Icons.star_rounded,),
                                        Text('${buku.fields.averageRating}'),
                                      ]
                                    ),
                                    SizedBox(width: 10),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.message_rounded,
                                          size: 19,
                                        ),
                                        Text('${buku.fields.reviewCount}'),
                                      ]
                                    ),
                                  ]
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                  ),
            
                  SizedBox(height: 15),
                  Container(
                    // color: Color.fromRGBO(248, 245, 36, 1),
                    child: new DescriptionTextWidget(text: buku.fields.description),
                  ),
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () { 
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ReviewBuku(idBuku: buku.pk,)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Color.fromRGBO(36, 248, 160, 1),
                        border: Border.all(
                          color: const Color.fromARGB(255, 153, 153, 153),
                          width: 2.5,  
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(7))
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 15),
                          Column(
                            children: [
                              const Icon(Icons.star_rounded,
                                color: Color.fromRGBO(253, 207, 3, 1),
                                size: 75,
                              ),
                              Row(
                                children: [
                                  Text('${buku.fields.averageRating}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14
                                    ),
                                  ),
                                  const Text("/5,0",
                                    style: TextStyle(
                                      color: Color.fromARGB(87, 74, 75, 75),
                                    ),
                                  ),
                                  
                                ],
                              ),
                              Text("${buku.fields.ratingCount} rating",
                                    style: TextStyle(
                                      color: Color.fromARGB(87, 74, 75, 75),
                                    ),
                                  )
                            ],
                          ),
                          SizedBox(width: 15),
                          Container(
                            // color: Color.fromRGBO(231, 35, 35, 1),
                            child: Column(
                              children: [                  
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: LinearPercentIndicator(
                                    width: MediaQuery.of(context).size.width -210,
                                    animation: true,
                                    lineHeight: 10.0,
                                    animationDuration: 1000,
                                    percent: buku.fields.fiveStarRatings/buku.fields.ratingCount,
                                    leading: const Row(children: [Icon(Icons.star_rounded), Text("5")]),
                                    progressColor: Color.fromARGB(255, 134, 134, 255),
                                  ),
                                ),
                                                
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: LinearPercentIndicator(
                                    width: MediaQuery.of(context).size.width -210,
                                    animation: true,
                                    lineHeight: 10.0,
                                    animationDuration: 1000,
                                    percent: buku.fields.fourStarRatings/buku.fields.ratingCount,
                                    leading: const Row(children: [Icon(Icons.star_rounded), Text("4")]),
                                    progressColor: const Color.fromARGB(255, 134, 134, 255),
                                  ),
                                ),
                                                
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: LinearPercentIndicator(
                                    width: MediaQuery.of(context).size.width -210,
                                    animation: true,
                                    lineHeight: 10.0,
                                    animationDuration: 1000,
                                    percent: buku.fields.threeStarRatings/buku.fields.ratingCount,
                                    leading: const Row(children: [Icon(Icons.star_rounded), Text("3")]),
                                    progressColor: const Color.fromARGB(255, 134, 134, 255),
                                  ),
                                ),                 
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: LinearPercentIndicator(
                                    width: MediaQuery.of(context).size.width -210,
                                    animation: true,
                                    lineHeight: 10.0,
                                    animationDuration: 1000,
                                    percent: buku.fields.twoStarRatings/buku.fields.ratingCount,
                                    leading: const Row(children: [Icon(Icons.star_rounded), Text("2")]),
                                    progressColor: const Color.fromARGB(255, 134, 134, 255),
                                  ),
                                ),                 
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: LinearPercentIndicator(
                                    width: MediaQuery.of(context).size.width -210,
                                    animation: true,
                                    lineHeight: 10.0,
                                    animationDuration: 1000,
                                    percent: buku.fields.oneStarRatings/buku.fields.ratingCount,
                                    leading: const Row(children: [Icon(Icons.star_rounded), Text("1")]),
                                    progressColor: const Color.fromARGB(255, 134, 134, 255),
                                  ),
                                ),
                              ]
                            ),
                          )
                        ]
                      ),
                    )
                  )
                ],
              ),
            );
          }
        },
      ),
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

    if (widget.text.length > 200) {
      firstHalf = widget.text.substring(0, 200);
      secondHalf = widget.text.substring(200, widget.text.length);
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

class RatingBar extends StatefulWidget {
 final int totalRating;
 final int sumOfRatings;

 RatingBar({required this.totalRating, required this.sumOfRatings});

 @override
 _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
 double _rating = 0.0;

 @override
 void initState() {
    super.initState();
    _calculateRating();
 }

 void _calculateRating() {
    setState(() {
      _rating = widget.sumOfRatings / widget.totalRating;
    });
 }

 @override
 Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: _rating,
      backgroundColor: Colors.grey[200],
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      semanticsLabel: 'Rating: $_rating out of 1',
    );
 }
}

class AddReviewDialog extends StatelessWidget {
 final Function(String username, int rating) onSubmit;

 AddReviewDialog({required this.onSubmit});

 @override
 Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? _username;
    int? _rating;

    return AlertDialog(
      title: Text('Add Review'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Username'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                 return 'Please enter a username';
                }
                return null;
              },
              onSaved: (value) => _username = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Rating'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                 return 'Please enter a rating';
                }
                return null;
              },
              onSaved: (value) => _rating = int.tryParse(value!),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              onSubmit(_username!, _rating!);
              Navigator.of(context).pop();
            }
          },
          child: Text('Submit'),
        ),
      ],
    );
 }
}