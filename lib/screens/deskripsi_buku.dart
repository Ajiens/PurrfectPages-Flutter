import 'dart:async';


import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:purrfect_pages/models/book.dart';
import 'package:purrfect_pages/screens/review_buku.dart';

class DeskripsiBuku extends StatefulWidget {
  final int idBuku;

  DeskripsiBuku({Key? key, required this.idBuku}) : super(key: key);

  @override
  _DeskripsiBukuState createState() => _DeskripsiBukuState();
}

class _DeskripsiBukuState extends State<DeskripsiBuku> {
  late Book buku;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<Book> fetchData() async {

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


  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
  TextEditingController komentarController = TextEditingController();
  TextEditingController ratingController = TextEditingController();

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
                mainAxisSize: MainAxisSize.max,
                children: [
                   Row(
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
                    Align(
                      alignment: AlignmentDirectional(0.00, 0.00),
                      child: Padding(
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
                                Text(buku.fields.title),
                                Text(buku.fields.author),
                                Text('ISBN: ${buku.fields.isbn}  •  ${buku.fields.numberOfPages} halaman'),
                                Text('${buku.fields.datePublished}')
                              ],
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(Icons.star_rounded,),
                                      Text('${buku.fields.averageRating}'),
                                    ]
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        Icons.favorite_rounded,
                                        size: 19,
                                      ),
                                      Text('100'),
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
                 Column(
                    mainAxisSize: MainAxisSize.max,
                    
                    children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black87, backgroundColor: Colors.grey[300],
                          minimumSize: Size(88, 36),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                            ),
                          ),
                          onPressed: () { 
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ReviewBuku(idBuku: buku.pk,)));
                          },
                          child: Text('See the review'),
                        ),
                        ElevatedButton(
                      onPressed: () async {
                        await showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Stack(
                                    clipBehavior: Clip.none,
                                    children: <Widget>[
                                      Positioned(
                                        right: -40,
                                        top: -40,
                                        child: InkResponse(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const CircleAvatar(
                                            backgroundColor: Colors.red,
                                            child: Icon(Icons.close),
                                          ),
                                        ),
                                      ),
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: TextFormField(
                                                controller: komentarController,
                                                decoration: InputDecoration(
                                                hintText: "Komentar",
                                                labelText: "Komentar",
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                ),
                                                ),
                                              ),

                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: TextFormField(
                                                controller: ratingController,
                                                decoration: InputDecoration(
                                                  hintText: "Rating",
                                                  labelText: "Rating",
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                  ),
                                                ),
                                                validator: (String? value) {
                                                  if (value == null || value.isEmpty) {
                                                    return "Rating tidak boleh kosong!";
                                                  }
                                                  if (int.tryParse(value) == null) {
                                                    return "Harga harus berupa angka!";
                                                  }
                                                  if (int.parse(value) < 1 || int.parse(value) > 5) {
                                                    return "Rating harus antara 1 sampai 5!";
                                                  }
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: ElevatedButton(
                                                child: const Text('Submit'),
                                                // Navigator.of(context).pop(); // Close the popup
                                                onPressed: () async {
                                                  if (_formKey.currentState!.validate()) {
                                                    String _komentar = komentarController.text;
                                                    int _rating =  int.parse(ratingController.text);

                                                    print(_rating);
                                                    // Kirim ke Django dan tunggu respons
                                                    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                                                    print("masuk sini");
                                                    final response = await request.postJson(
                                                        "http://localhost:8000/deskripsi_buku/create-review-flutter/",
                                                        jsonEncode(<String, String>{
                                                          'komentar': _komentar,
                                                          'rating': _rating.toString(),
                                                          'buku_id': buku.pk.toString(),
                                                          // TODO: Sesuaikan field data sesuai dengan aplikasimu
                                                        }));
                                                    if (response['status'] == 'success') {
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(const SnackBar(
                                                        content: Text("Ulasan Anda berhasil disimpan!"),
                                                      ));
                                                      Navigator.of(context).pop(); // Close the popup
                                                    } else {
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(const SnackBar(
                                                        content:
                                                        Text("Terdapat kesalahan, silakan coba lagi."),
                                                      ));
                                                    }
                                                  }
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                      },
                      child: const Text('Add Review'),
                    ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
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