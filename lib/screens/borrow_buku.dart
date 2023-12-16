import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:purrfect_pages/models/borrow.dart';
import 'dart:convert';
import 'package:purrfect_pages/screens/navbar.dart';

class Pinjam_Buku extends StatefulWidget {
  const Pinjam_Buku({Key? key}) : super(key: key);

  @override
  _Pinjam_BukuState createState() => _Pinjam_BukuState();
}

class _Pinjam_BukuState extends State<Pinjam_Buku>{
  int _currentIndex = 1;
     
  Future<List<Borrow>> getFilteredPeminjaman() async {
    final request = context.watch<CookieRequest>();
    final response = await request.get("http://localhost:8000/pinjam_buku/get-books/");
        
    List<Borrow> daftar_peminjaman = [];
    for (var d in response){
      if (d != null){
        daftar_peminjaman.add( Borrow.fromJson(d));
      }
    }
    return daftar_peminjaman;
  }

 
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Book')),
      body: FutureBuilder<List<Borrow>>(
        future: getFilteredPeminjaman(),
        builder: (context,AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
          }
          else {
                if (!snapshot.hasData) {
                return const Column(
                    children: [
                    Text(
                        "Tidak ada data produk.",
                        style:
                            TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                    ),
                    SizedBox(height: 8),
                    ],
                );
            }
            else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index){
                  Borrow pinjam = snapshot.data![index];
                  return Card(
                    elevation: 4, // Sesuaikan kebutuhan dengan elevasi yang diinginkan
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      subtitle: Text(pinjam.title),
                    ),
                  );
                },
              );
            }
            
          }
          
          
        }
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        }
      )
    );
  }
}