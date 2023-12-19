import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:purrfect_pages/main/login.dart';
import 'package:purrfect_pages/models/borrow.dart';
import 'package:purrfect_pages/models/user.dart';
import 'package:purrfect_pages/screens/navbar.dart';
import 'package:provider/provider.dart';

class Pinjam_Buku extends StatefulWidget {
  const Pinjam_Buku({Key? key}) : super(key: key);

  @override
  _Pinjam_BukuState createState() => _Pinjam_BukuState();
}

class _Pinjam_BukuState extends State<Pinjam_Buku> {
  int _currentIndex = 2;
  late List<Borrow> _books = [];

  @override
  void initState() {
    super.initState();
    fetchData().then((books) {
      setState(() {
        _books = books;
      });
    });
  }

  Future<List<Borrow>> fetchData() async {
    final request = context.read<CookieRequest>();
    final response = await request.get('https://alwan.pythonanywhere.com/pinjam_buku/get-books/');

    List<Borrow> myBook = [];

    for (var d in response) {
      if (d != null) {
        myBook.add(Borrow.fromJson(d));
      }
    }
    return myBook;
  }

  Future<void> returnBook(int index) async {
    final request = context.read<CookieRequest>();
    final response = await request.postJson(
      "https://alwan.pythonanywhere.com/pinjam_buku/kembalikan_flutter/${_books[index].pk}/${LoginPage.uname}",
      jsonEncode({'name': _books[index].pk}),
    );
    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Buku berhasil dikembalikan")),
      );
      setState(() {
        _books.removeAt(index); // Hapus buku dari daftar setelah pengembalian berhasil
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Book'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      
      body: FutureBuilder<List<Borrow>>(
        future: fetchData(),
        builder: (context, AsyncSnapshot<List<Borrow>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No data available'),
            );
          } else {
            return ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                Borrow pinjam = _books[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: SizedBox(
                      child: Image.network(
                        pinjam.coverLink, // Gambar buku
                        fit: BoxFit.cover, // Atur penyesuaian gambar
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pinjam.title), // Judul buku
                        Text(pinjam.author), // Penulis buku (opsional)
                        Text("Lama Peminjaman: ${pinjam.lamaPeminjaman.toString()} hari"),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        await returnBook(index);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigo, // Mengatur warna latar belakang tombol
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Mengatur padding tombol
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bookmark, // Ganti dengan ikon yang diinginkan
                            size: 16, // Atur ukuran ikon
                            color: Colors.white,
                          ),
                          SizedBox(width: 4), // Beri jarak antara ikon dan teks
                          Text(
                            'Kembalikan Buku',
                            style: TextStyle(
                              fontSize: 12, // Mengatur ukuran teks tombol
                              color: Colors.white, // Warna teks
                            ),      
                          ),
                        ],
                      ),
                    ),
                  ),
                );
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
        }, backgroundColor: Colors.indigo,
      ),
    );
  }
}
