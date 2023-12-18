// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:http/http.dart' as http;
// import 'package:purrfect_pages/models/borrow.dart';

// class DetailPinjam extends StatefulWidget {
//   final int idBuku;

//   DetailPinjam({Key? key, required this.idBuku}) : super(key: key);

//   @override
//   _DetailPinjamState createState() => _DetailPinjamState();
// }

// class _DetailPinjamState extends State<DetailPinjam>{
//   late Borrow buku;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<Borrow> fetchData() async {
//     var url = Uri.parse('http://127.0.0.1:8000/api/books/${buku.pk}/');
//     var response = await http.get(url, headers: {"Content-Type": "application/json"});

//     if (response.statusCode == 200) {
//       Map<String, dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
//       buku = Borrow.fromJson(jsonData);
//       return buku;
//     } else {
//       throw Exception('Failed to load book details');
//     }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Deskripsi Buku')),
//       body: FutureBuilder<Borrow>(
//         future: fetchData(),
//         builder: (context, AsyncSnapshot<Borrow> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else if (!snapshot.hasData || snapshot.data == null) {
//             return Center(
//               child: Text('No book data available'),
//             );
//           } else {
//             buku = snapshot.data!;

//             return SingleChildScrollView(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.network(
//                           '${buku.coverLink}',
//                           width: 102,
//                           height: 123,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(9),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(buku.title),
//                             Text(buku.author),
//                             Row(
//                               children: [
//                                 Icon(Icons.star_rounded),
//                                 Text('${buku.averageRating}'),
//                                 Text('${buku.lamaPeminjaman}'),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Icon(Icons.favorite_rounded, size: 19),
//                                 Text('100'),
//                               ],
//                             ),
//                             ElevatedButton(
//                               onPressed: () {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text('Buku berhasil dikembalikan')),
//                                 );
//                               },
//                               child: Text('Kembalikan Buku'),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
