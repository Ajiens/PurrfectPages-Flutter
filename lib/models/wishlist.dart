// To parse this JSON data, do
//
//     final wishlist = wishlistFromJson(jsonString);

import 'dart:convert';

List<Wishlist> wishlistFromJson(String str) => List<Wishlist>.from(json.decode(str).map((x) => Wishlist.fromJson(x)));

String wishlistToJson(List<Wishlist> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Wishlist {
    int pk;
    String title;
    String coverLink;
    String author;
    double averageRating;
    int harga;
    String keterangan;

    Wishlist({
        required this.pk,
        required this.title,
        required this.coverLink,
        required this.author,
        required this.averageRating,
        required this.harga,
        required this.keterangan,
    });

    factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
        pk: json["pk"],
        title: json["title"],
        coverLink: json["cover_link"],
        author: json["author"],
        averageRating: json["average_rating"]?.toDouble(),
        harga: json["harga"],
        keterangan: json["keterangan"],
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "title": title,
        "cover_link": coverLink,
        "author": author,
        "average_rating": averageRating,
        "harga": harga,
        "keterangan": keterangan,
    };
}