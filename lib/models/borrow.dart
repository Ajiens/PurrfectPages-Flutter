// To parse this JSON data, do
//
//     final borrow = borrowFromJson(jsonString);

import 'dart:convert';

List<Borrow> borrowFromJson(String str) => List<Borrow>.from(json.decode(str).map((x) => Borrow.fromJson(x)));

String borrowToJson(List<Borrow> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Borrow {
    int pk;
    String title;
    String coverLink;
    String author;
    double averageRating;
    int lamaPeminjaman;
    String lastLogin;

    Borrow({
        required this.pk,
        required this.title,
        required this.coverLink,
        required this.author,
        required this.averageRating,
        required this.lamaPeminjaman,
        required this.lastLogin,
    });

    factory Borrow.fromJson(Map<String, dynamic> json) => Borrow(
        pk: json["pk"],
        title: json["title"],
        coverLink: json["cover_link"],
        author: json["author"],
        averageRating: json["average_rating"]?.toDouble(),
        lamaPeminjaman: json["lama_peminjaman"],
        lastLogin: json["last_login"],
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "title": title,
        "cover_link": coverLink,
        "author": author,
        "average_rating": averageRating,
        "lama_peminjaman": lamaPeminjaman,
        "last_login": lastLogin,
    };
}
