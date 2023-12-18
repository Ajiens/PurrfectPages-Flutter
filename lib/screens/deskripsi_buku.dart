import 'dart:async';


import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:purrfect_pages/models/book.dart';
import 'package:purrfect_pages/models/review.dart';
import 'package:purrfect_pages/screens/review_buku.dart';

import 'package:percent_indicator/percent_indicator.dart';

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
    final request = context.watch<CookieRequest>();
    
  TextEditingController komentarController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();
  TextEditingController lamaPeminjamanController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Deskripsi Buku')),
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
                  Container(
                    // color: Color.fromRGBO(153, 0, 255, 0.849),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black87, backgroundColor: Color.fromARGB(255, 204, 204, 206),
                            
                            padding: EdgeInsets.fromLTRB(5, 17, 5, 17),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(7)),
                              ),
                            ),
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
                                                          "https://alwan.pythonanywhere.com/deskripsi_buku/create-review-flutter/",
                                                          jsonEncode(<String, String>{
                                                            'komentar': _komentar,
                                                            'rating': _rating.toString(),
                                                            'buku_id': buku.pk.toString(),
                                                            // TODO: Sesuaikan field data sesuai dengan aplikasimu
                                                          }));
                                                      print(response['status']);
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
                            child: 
                            Icon(Icons.chat_bubble_outline),
                            
                          ),

                          SizedBox(width: 10),
                          //Wishlist
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black87, backgroundColor: Color.fromARGB(255, 204, 204, 206),
                            padding: EdgeInsets.fromLTRB(5, 17, 5, 17),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(7)),
                              ),
                            ),
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
                                                controller: keteranganController,
                                                decoration: InputDecoration(
                                                hintText: "Keterangan",
                                                labelText: "Keterangan",
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: ElevatedButton(
                                                child: const Text('Submit'),
                                                // Navigator.of(context).pop(); // Close the popup
                                                onPressed: () async {
                                                  if (_formKey.currentState!.validate()) {
                                                    String _keterangan = keteranganController.text;

                                                    // Kirim ke Django dan tunggu respons
                                                    final response = await request.postJson(
                                                    "https://alwan.pythonanywhere.com/wishlist/add-flutter/${buku.pk}/",
                                                    jsonEncode(<String, String>{
                                                        'keterangan': _keterangan,
                                                        'buku_id': buku.pk.toString(),
                                                    }));
                                                    if (response['status'] == 'success') {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text("Succes"),
                                                          content: Text("Book added to your wishlist!!"),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Text("OK"),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    } else {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text("Failed"),
                                                          content: Text("Book is already in your wishlist!"),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Text("Close"),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                    _formKey.currentState!.reset();
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
                            child: 
                            Icon(Icons.bookmark_add_outlined),
                            
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: MediaQuery.of(context).size.width - 164,
                            child: 
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                            foregroundColor: Color.fromARGB(255, 241, 245, 255), backgroundColor: Color.fromARGB(255, 134, 134, 255),
                            padding: EdgeInsets.fromLTRB(30, 17, 80, 17),
                            
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(7)),
                              ),
                            ),
                            onPressed: () async {
                              await showDialog<void>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content:Stack(
                                    clipBehavior:Clip.none,
                                    children: <Widget> [
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
                                      Form (
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: TextFormField(
                                                controller: lamaPeminjamanController,
                                                decoration: InputDecoration(
                                                hintText: "Lama Peminjaman",
                                                labelText: "Lama Peminjaman",
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(5.0)
                                                  ),
                                                ),
                                                validator: (String? value) {
                                                        if (value == null || value.isEmpty) {
                                                          return "Lama peminjaman tidak boleh kosong";
                                                        }
                                                        if (int.tryParse(value) == null || int.parse(value)<1) {
                                                          return "Lama peminjman harus valid";
                                                        }
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: ElevatedButton(
                                                child: const Text('Pinjam'),
                                                onPressed: () async{
                                                  if(_formKey.currentState!.validate()){
                                                    int _lamaPeminjaman = int.parse(lamaPeminjamanController.text); 
                                                    
                                                    
                                                    final response = await request.postJson(
                                                      "https://alwan.pythonanywhere.com/pinjam_buku/pinjam_buku_flutter/${widget.idBuku}/",
                                                            jsonEncode(<String, String>{
                                                            'lama_peminjaman': _lamaPeminjaman.toString(),
                                                            }));
                                                      
                                                    if (response['status'] == 'success') {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text("Sukses"),
                                                          content: Text("Buku berhasil dipinjam!"),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Text("OK"),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    } else {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text("Gagal"),
                                                          content: Text("Buku tidak tersedia."),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Text("OK"),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                  }}
                                                  lamaPeminjamanController.clear();
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
                            child: const Row(
                              children: [
                                Icon(Icons.shopping_cart_rounded),
                                SizedBox(width: 15),
                                Text('Pinjam Buku'),
                              ],
                            )
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